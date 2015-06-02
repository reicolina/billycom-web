class AddAddressFieldsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :address, :string
    add_column :sites, :city, :string
    add_column :sites, :province_or_state, :string
    add_column :sites, :postal_or_zip_code, :string
    add_column :sites, :country, :string
  end

  def self.down
    remove_column :sites, :address
    remove_column :sites, :city
    remove_column :sites, :province_or_state
    remove_column :sites, :postal_or_zip_code
    remove_column :sites, :country
  end
end
