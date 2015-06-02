class AddRatedToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :rated, :boolean, :default => false
  end

  def self.down
    remove_column :temp_calls, :rated
  end
end
