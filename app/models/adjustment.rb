class Adjustment < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :description, :amount, :apply_on
  belongs_to :site
  belongs_to :account
  validates_presence_of :description
  validates_presence_of :amount
  validates_numericality_of :amount
end
