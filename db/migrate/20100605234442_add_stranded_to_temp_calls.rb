class AddStrandedToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :stranded, :boolean, :default => false
  end

  def self.down
    remove_column :temp_calls, :stranded
  end
end
