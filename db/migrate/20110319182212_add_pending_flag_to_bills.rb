class AddPendingFlagToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :pending_flag, :boolean, :default => false
  end

  def self.down
    remove_column :bills, :pending_flag
  end
end
