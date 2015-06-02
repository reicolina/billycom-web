class RemoveRateFromTempCall < ActiveRecord::Migration
  def self.up
    remove_column :temp_calls, :rate
  end

  def self.down
    add_column :temp_calls, :rate, :decimal, :precision => 8, :scale => 2
  end
end
