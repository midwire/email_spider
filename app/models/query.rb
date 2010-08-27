class Query < ActiveRecord::Base
  attr_accessible :terms
  has_many :results
  accepts_nested_attributes_for :results, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }
  
  def self.search(params)
    @query = Query.create(params)
    Google::Search::Web.new(:query => params[:terms]).each do |r|
      @query.results << Result.create(
        :visible_uri => r.visible_uri, 
        :uri => r.uri
      )
    end
    @query
  end
end
