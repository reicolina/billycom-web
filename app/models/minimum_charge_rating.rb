class MinimumChargeRating < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :name, :duration_sec, :percentage, :fixed_minimum_charge
  belongs_to :site
  before_destroy :is_not_attached_to_a_rating_plan
  has_many :rating_plans
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
  validates_presence_of :duration_sec
  validates_numericality_of :duration_sec
  validates_numericality_of :fixed_minimum_charge
  validates_numericality_of :percentage, :greater_than =>0, :less_than_or_equal_to =>100
  
  def is_not_attached_to_a_rating_plan
    return if rating_plans.empty?
    errors[:base] << "This minimun charge rating is being used by a rating plan so it cannot be deleted."
    false # If you return anything else, the callback will not stop the destroy from happening
  end
    
end