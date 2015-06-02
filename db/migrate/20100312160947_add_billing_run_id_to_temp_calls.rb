class AddBillingRunIdToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :billing_run_id, :integer
  end

  def self.down
    remove_column :temp_calls, :billing_run_id
  end
end
