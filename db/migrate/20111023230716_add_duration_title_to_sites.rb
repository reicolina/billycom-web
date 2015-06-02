class AddDurationTitleToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :duration_title, :string, :default=>'Duration(min.)'
  end

  def self.down
    remove_column :sites, :duration_title
  end
end
