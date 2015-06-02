class AddProvStateToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :prov_state, :string
  end

  def self.down
    remove_column :temp_calls, :prov_state
  end
end
