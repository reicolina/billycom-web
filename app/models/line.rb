class Line < ActiveRecord::Base  
  acts_as_tenant(:site)
  attr_accessible :active, :number, :type_of_line, :use, :line_rate, :rating_plan_id, :port_date
  belongs_to :site
  belongs_to :account
  belongs_to :rating_plan
  validates_presence_of :number
  validates_uniqueness_to_tenant :number
  validates_numericality_of :sequence, :allow_blank =>true
  validates_presence_of :line_rate
  validates_numericality_of :line_rate
  validates_presence_of :rating_plan
  
  require 'memoist'
  
  class << self
    extend Memoist
    def search_line(number)
      self.find_by_number(number, :select => 'account_id, rating_plan_id', :include => [:rating_plan , {:rating_plan => :minimum_charge_rating}, :account])
    end
    memoize :search_line
  end

end
