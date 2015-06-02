class AddDestinationProvStateToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :destination_prov_state, :string
  end

  def self.down
    remove_column :providers, :destination_prov_state
  end
end
