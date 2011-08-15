require 'open-uri'

class Result < ActiveRecord::Base
  attr_accessible :query_id, :name, :location, :email, :visible_uri, :uri
  attr_accessor :links_followed, :link_count, :depth_followed

  belongs_to :query
  has_many :emails, :dependent => :destroy

  validates_uniqueness_of :visible_uri, :on => :create, :message => "must be unique"
  validates_uniqueness_of :uri, :on => :create, :message => "must be unique"

  after_save :harvest_emails

  private

    def is_contact_link(item)
      return true if item.text =~ /contact/i
      return true if item[:href] =~ /contact/i
      return false
    end

    def is_mailto_link(item)
      return true if item[:href] =~ /mailto/i
      return false
    end
    
    def get_address_from_mailto_link(item)
      return item[:href].gsub(/mailto:/, '')
    end
    
    def search_for_emails(href)
      @depth_followed += 1
      href = "http://#{visible_uri}#{href}" unless href =~ /^http/i
      puts "\n-----"
      puts ">>> Searching: #{href}"
      doc = Nokogiri::HTML(open(href))
      doc.css("a").each do |item|
        if is_contact_link(item) and !@links_followed.include? item[:href]
          @links_followed << item[:href]
          @link_count += 1
          if @link_count >= 15
            puts ">>> Reached Email Limit For: #{href}"
            return
          end
          if @depth_followed >= 10
            puts ">>> Reached Nested Depth Level (#{@depth_followed}) For: #{href}"
            return
          end
          puts ">>> Following Contact Link: #{item.text}: #{item[:href]}"
          search_for_emails(item[:href])
        end
        
        if is_mailto_link(item)
          address = get_address_from_mailto_link(item)
          puts  ">>> Adding Email: #{address}"
          emails << Email.create(:address => address)
        end
      end
      @depth_followed -= 1
    rescue Exception => e
      logger.error { "Exception: #{e.inspect}" }
      return
    end

    def harvest_emails
      @depth_followed = 0
      @links_followed = []
      @link_count = 0
      search_for_emails(uri)
    end
end
