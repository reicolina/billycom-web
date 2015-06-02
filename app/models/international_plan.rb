class InternationalPlan < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :name
  belongs_to :site
  before_destroy :is_not_attached_to_a_rating_plan
  has_many :rating_plans
  has_many :international_rates, :dependent => :destroy
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
  
  def is_not_attached_to_a_rating_plan
    return if rating_plans.empty?
    errors[:base] << "This international plan is being used by a rating plan so it cannot be deleted."
    false # If you return anything else, the callback will not stop the destroy from happening
  end
  
end
