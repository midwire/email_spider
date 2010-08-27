require 'open-uri'

class Result < ActiveRecord::Base
  attr_accessible :query_id, :name, :location, :email, :visible_uri, :uri
  attr_accessor :links_followed, :link_count

  belongs_to :query
  has_many :emails

  validates_presence_of :visible_uri, :on => :create, :message => "can't be blank"
  validates_presence_of :uri, :on => :create, :message => "can't be blank"

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
      href = "http://#{visible_uri}#{href}" unless href =~ /^http/i
      logger.debug { ">>> Searching: #{href}" }
      doc = Nokogiri::HTML(open(href))
      doc.css("a").each do |item|
        if is_contact_link(item) and !@links_followed.include? item[:href]
          @links_followed << item[:href]
          @link_count += 1
          if @link_count >= 15
            logger.debug { ">>> Reached Email Limit For: #{href}" } 
          end
          logger.debug { ">>> Following Contact Link: #{item.text}: #{item[:href]}" }
          search_for_emails(item[:href])
        end
        
        if is_mailto_link(item)
          address = get_address_from_mailto_link(item)
          logger.debug {  ">>> Adding Email: #{address}" }
          emails << Email.create(:address => address)
        end
      end
    rescue Exception => e
      logger.error { "Exception: #{e.inspect}" }
      return
    end

    def harvest_emails
      @links_followed = []
      @link_count = 0
      search_for_emails(uri)
    end
end
