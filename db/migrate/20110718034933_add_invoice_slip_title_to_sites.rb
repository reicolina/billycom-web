class AddInvoiceSlipTitleToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :invoice_slip_title, :string, :default=>'                         Payment Return Slip'
  end

  def self.down
    remove_column :sites, :invoice_slip_title
  end
end
