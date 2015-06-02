class AddBilledNumberTitleToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :billed_number_title, :string, :default=>'Number'
  end

  def self.down
    remove_column :sites, :billed_number_title
  end
end
