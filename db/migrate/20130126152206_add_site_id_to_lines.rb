class AddSiteIdToLines < ActiveRecord::Migration
  def change
  	add_column :lines, :site_id, :integer
  end
end
