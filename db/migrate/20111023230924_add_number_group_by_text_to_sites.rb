class AddNumberGroupByTextToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :number_group_by_text, :string, :default=>'Phone Number'
  end

  def self.down
    remove_column :sites, :number_group_by_text
  end
end
