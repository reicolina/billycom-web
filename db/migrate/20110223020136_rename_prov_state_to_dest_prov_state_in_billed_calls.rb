class RenameProvStateToDestProvStateInBilledCalls < ActiveRecord::Migration
  def self.up
    change_table :billed_calls do |t|
      t.rename :prov_state, :dest_prov_state
    end
  end

  def self.down
    change_table :billed_calls do |t|
      t.rename :dest_prov_state, :prov_state
    end
  end
end
