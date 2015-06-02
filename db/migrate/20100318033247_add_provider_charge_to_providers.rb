class AddProviderChargeToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :provider_charge, :integer
  end

  def self.down
    remove_column :providers, :provider_charge
  end
end
