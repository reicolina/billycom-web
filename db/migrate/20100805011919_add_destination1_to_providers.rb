class AddDestination1ToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :destination1, :integer
  end

  def self.down
    remove_column :providers, :destination1
  end
end
