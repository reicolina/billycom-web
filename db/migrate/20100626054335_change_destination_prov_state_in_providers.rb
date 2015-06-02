class ChangeDestinationProvStateInProviders < ActiveRecord::Migration
  def self.up
    change_column :providers, :destination_prov_state, :integer
  end

  def self.down
    change_column :providers, :destination_prov_state, :string
  end
end
