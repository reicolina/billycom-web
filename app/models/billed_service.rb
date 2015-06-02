class BilledService < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :type_of_service, :use, :amount_charged
  belongs_to :site
  belongs_to :bill
end
