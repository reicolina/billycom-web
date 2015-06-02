class AddBillInquiriesFieldsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :bill_inquiries_line_1, :string
    add_column :sites, :bill_inquiries_line_2, :string
    add_column :sites, :bill_inquiries_line_3, :string
  end

  def self.down
    remove_column :sites, :bill_inquiries_line_1
    remove_column :sites, :bill_inquiries_line_2
    remove_column :sites, :bill_inquiries_line_3
  end
end
