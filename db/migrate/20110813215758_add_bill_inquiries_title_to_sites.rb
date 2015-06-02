class AddBillInquiriesTitleToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :bill_inquiries_title, :string, :default=>'Bill Inquiries'
  end

  def self.down
    remove_column :sites, :bill_inquiries_title
  end
end
