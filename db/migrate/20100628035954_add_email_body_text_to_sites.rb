class AddEmailBodyTextToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :email_body_text, :text
  end

  def self.down
    remove_column :sites, :email_body_text
  end
end
