class AddSiteIdToBills < ActiveRecord::Migration
  def change
  	add_column :bills, :site_id, :integer
  end
end
