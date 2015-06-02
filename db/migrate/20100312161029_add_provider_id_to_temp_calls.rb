class AddProviderIdToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :provider_id, :integer
  end

  def self.down
    remove_column :temp_calls, :provider_id
  end
end
