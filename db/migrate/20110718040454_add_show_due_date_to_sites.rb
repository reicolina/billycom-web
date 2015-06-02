class AddShowDueDateToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :show_due_date, :boolean, :default=>true
  end

  def self.down
    remove_column :sites, :show_due_date
  end
end
