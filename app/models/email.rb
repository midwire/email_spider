class Email < ActiveRecord::Base
  attr_accessible :result_id, :address
  belongs_to :result
  validates_uniqueness_of :address, :on => :create, :message => "must be unique"
end
