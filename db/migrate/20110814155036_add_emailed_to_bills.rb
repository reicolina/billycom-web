class AddEmailedToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :emailed, :boolean, :default => false
  end

  def self.down
    remove_column :bills, :emailed
  end
end
