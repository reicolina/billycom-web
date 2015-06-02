class AddCurrencySymbolToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :currency_symbol, :string, :default=>'$'
  end

  def self.down
    remove_column :sites, :currency_symbol
  end
end
