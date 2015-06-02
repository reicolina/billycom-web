class AddCcYourselfToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :cc_yourself, :boolean
  end

  def self.down
    remove_column :sites, :cc_yourself
  end
end
