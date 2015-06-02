class AddLogoFilenameToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :logo_filename, :string
  end

  def self.down
    remove_column :sites, :logo_filename
  end
end
