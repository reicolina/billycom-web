class AddSiteIdToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :site_id, :integer
  end
end
