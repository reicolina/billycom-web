class SalesRep < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :name
  belongs_to :site
  before_destroy :is_not_attached_to_an_account
  has_many :accounts
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
  
  def is_not_attached_to_an_account
    return if accounts.empty?
    errors[:base] << "This sales rep is being used by an account so it cannot be deleted."
    false # If you return anything else, the callback will not stop the destroy from happening
  end
  
end
