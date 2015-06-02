class AddLogo2ToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :logo2, :binary
  end

  def self.down
    remove_column :sites, :logo2
  end
end
