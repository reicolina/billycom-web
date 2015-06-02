class OtherService < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :type_of_service, :use, :rate, :port_date
  belongs_to :site
  belongs_to :account
  validates_presence_of :type_of_service
  validates_presence_of :rate
  validates_numericality_of :rate
end
