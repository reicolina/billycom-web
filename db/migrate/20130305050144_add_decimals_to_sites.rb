class AddDecimalsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :decimals, :integer, :default => 2
  end
end
