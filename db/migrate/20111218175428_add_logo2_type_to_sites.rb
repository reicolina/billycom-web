class AddLogo2TypeToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :logo2_type, :string
  end

  def self.down
    remove_column :sites, :logo2_type
  end
end
