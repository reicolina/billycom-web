class BilledLine < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :number, :type_of_line, :use, :amount_charged
  belongs_to :site
  belongs_to :bill
end
