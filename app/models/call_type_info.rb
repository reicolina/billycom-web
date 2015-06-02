class CallTypeInfo < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :name, :abbreviation, :call_type, :fixed_rate, :cdr_charge_factor, :is_calling_card
  belongs_to :site
  validates_presence_of :name
  validates_presence_of :abbreviation
  validates_presence_of :call_type
  validates_uniqueness_to_tenant :abbreviation, :scope => [:is_calling_card]
  
  NON_OVERSEAS = 0
  OVERSEAS = 1
  OVERSEAS_MOBILE = 2
  CARIBBEAN = 3
  CARIBBEAN_MOBILE = 4
  FIXED_RATE = 5
  
  require 'memoist'
  
  class << self
    
    extend Memoist
    def search_abbreviation(abbreviation)
      self.find_by_abbreviation(abbreviation)
    end
    memoize :search_abbreviation
    
    def get_call_type_name(call_type)
      case call_type
        when NON_OVERSEAS then "Non Overseas"
        when OVERSEAS then "Overseas"
        when OVERSEAS_MOBILE then "Overseas Mobile"
        when CARIBBEAN then "Caribbean"
        when CARIBBEAN_MOBILE then "Caribbean Mobile"
        when FIXED_RATE then "Fixed Rate"
      end
    end
    
  end
    
end
