class Tax < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :name, :rate
  belongs_to :site
  has_and_belongs_to_many :accounts
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
  validates_numericality_of :rate, :greater_than =>0, :less_than_or_equal_to =>100
  
  def assign_to_all_clients
    accounts = Account.all
    accounts.each do |account|
      account.taxes << self
      account.save
    end
    account = nil
    accounts = nil
  end
  
end