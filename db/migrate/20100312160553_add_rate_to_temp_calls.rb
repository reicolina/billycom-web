class AddRateToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :rate, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :temp_calls, :rate
  end
end
