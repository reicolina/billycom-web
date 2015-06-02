class AddLogo2FilenameToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :logo2_filename, :string
  end

  def self.down
    remove_column :sites, :logo2_filename
  end
end
