class LocalPlan < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :name, :rate, :increment_in_seconds
  belongs_to :site
  before_destroy :is_not_attached_to_a_rating_plan
  has_many :rating_plans
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
  validates_presence_of :increment_in_seconds
  validates_numericality_of :increment_in_seconds, :greater_than =>0
  validates_presence_of :rate
  validates_numericality_of :rate

  def is_not_attached_to_a_rating_plan
    return if rating_plans.empty?
    errors[:base] << "This local plan is being used by a rating plan so it cannot be deleted."
    false # If you return anything else, the callback will not stop the destroy from happening
  end  

end


