class AddToFromTitleToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :to_from_title, :string, :default=>'Destination'
  end

  def self.down
    remove_column :sites, :to_from_title
  end
end
