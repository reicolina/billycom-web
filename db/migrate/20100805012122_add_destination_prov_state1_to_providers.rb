class AddDestinationProvState1ToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :destination_prov_state1, :integer
  end

  def self.down
    remove_column :providers, :destination_prov_state1
  end
end
