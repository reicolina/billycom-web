class AddInvoiceDateTextToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :invoice_date_text, :string, :default=>'Invoice Date'
  end

  def self.down
    remove_column :sites, :invoice_date_text
  end
end
