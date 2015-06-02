class AddChargeTitleToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :charge_title, :string, :default=>'Charge'
  end

  def self.down
    remove_column :sites, :charge_title
  end
end
