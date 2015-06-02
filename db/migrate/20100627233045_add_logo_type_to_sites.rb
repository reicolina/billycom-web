class AddLogoTypeToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :logo_type, :string
  end

  def self.down
    remove_column :sites, :logo_type
  end
end
