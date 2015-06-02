class AddProvStateToBilledCalls < ActiveRecord::Migration
  def self.up
    add_column :billed_calls, :prov_state, :string
  end

  def self.down
    remove_column :billed_calls, :prov_state
  end
end
