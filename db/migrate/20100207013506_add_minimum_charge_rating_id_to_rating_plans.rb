class AddMinimumChargeRatingIdToRatingPlans < ActiveRecord::Migration
  def self.up
    add_column :rating_plans, :minimum_charge_rating_id, :integer
  end

  def self.down
    remove_column :rating_plans, :minimum_charge_rating_id
  end
end
