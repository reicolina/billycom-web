class AddCodeInternationalPlanIdIndexToInternationalRates < ActiveRecord::Migration
  def self.up
    add_index(:international_rates, [:code, :international_plan_id])
  end

  def self.down
    remove_index(:international_rates, [:code, :international_plan_id])
  end
end
