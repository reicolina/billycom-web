class AddInvoiceNumberTextToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :invoice_number_text, :string, :default=>'Invoice Number'
  end

  def self.down
    remove_column :sites, :invoice_number_text
  end
end
