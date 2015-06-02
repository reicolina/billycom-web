class AddSiteIdToOtherServices < ActiveRecord::Migration
  def change
  	add_column :other_services, :site_id, :integer
  end
end
