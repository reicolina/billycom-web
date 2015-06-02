class AddShowLogoOnPrintToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :show_logo_on_print, :boolean
  end

  def self.down
    remove_column :sites, :show_logo_on_print
  end
end
