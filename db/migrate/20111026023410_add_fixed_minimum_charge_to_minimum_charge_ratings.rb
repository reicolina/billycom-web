class AddFixedMinimumChargeToMinimumChargeRatings < ActiveRecord::Migration
  def self.up
    add_column :minimum_charge_ratings, :fixed_minimum_charge, :decimal, :precision => 8, :scale => 2, :default=> 0
  end

  def self.down
    remove_column :minimum_charge_ratings, :fixed_minimum_charge
  end
end
