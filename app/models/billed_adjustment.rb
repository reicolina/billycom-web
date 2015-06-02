class BilledAdjustment < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :description, :amount_charged
  belongs_to :site
  belongs_to :bill
end
