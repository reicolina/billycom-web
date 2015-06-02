class AddProviderChargeToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :provider_charge, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :temp_calls, :provider_charge
  end
end
