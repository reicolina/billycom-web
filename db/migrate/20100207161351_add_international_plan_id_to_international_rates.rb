class AddInternationalPlanIdToInternationalRates < ActiveRecord::Migration
  def self.up
    add_column :international_rates, :international_plan_id, :integer
  end

  def self.down
    remove_column :international_rates, :international_plan_id
  end
end
