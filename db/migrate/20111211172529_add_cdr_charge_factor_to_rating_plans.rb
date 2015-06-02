class AddCdrChargeFactorToRatingPlans < ActiveRecord::Migration
  def self.up
    add_column :rating_plans, :cdr_charge_factor, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :rating_plans, :cdr_charge_factor
  end
end
