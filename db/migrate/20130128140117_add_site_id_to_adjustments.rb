class AddSiteIdToAdjustments < ActiveRecord::Migration
  def change
  	add_column :adjustments, :site_id, :integer
  end
end
