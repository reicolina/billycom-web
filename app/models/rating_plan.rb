class RatingPlan < ActiveRecord::Base
  acts_as_tenant(:site)
  attr_accessible :name, :local_plan_id, :international_plan_id, :minimum_charge_rating_id, :cdr_charge_factor
  belongs_to :site
  before_destroy :is_not_attached_to_a_line
  belongs_to :international_plan
  belongs_to :local_plan
  belongs_to :minimum_charge_rating
  has_many :lines
  validates_presence_of :name
  validates_uniqueness_to_tenant :name
  validates_presence_of :international_plan_id
  validates_presence_of :local_plan_id
  validates_presence_of :minimum_charge_rating_id
  
  def is_not_attached_to_a_line
    return if lines.empty?
    errors[:base] << "This rating plan is being used by a line plan so it cannot be deleted."
    false # If you return anything else, the callback will not stop the destroy from happening
  end
  
end
