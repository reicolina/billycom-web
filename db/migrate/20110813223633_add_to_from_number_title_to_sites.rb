class AddToFromNumberTitleToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :to_from_number_title, :string, :default=>'Destination #'
  end

  def self.down
    remove_column :sites, :to_from_number_title
  end
end
