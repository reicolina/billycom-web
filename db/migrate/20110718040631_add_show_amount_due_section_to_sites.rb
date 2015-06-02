class AddShowAmountDueSectionToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :show_amount_due_section, :boolean, :default=>true
  end

  def self.down
    remove_column :sites, :show_amount_due_section
  end
end
