class AddFromEmailToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :from_email, :string
  end

  def self.down
    remove_column :sites, :from_email
  end
end
