class AddDateContainsTimeToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :date_contains_time, :boolean, :default => false
  end

  def self.down
    remove_column :providers, :date_contains_time
  end
end
