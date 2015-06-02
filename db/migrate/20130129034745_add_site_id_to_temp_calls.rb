class AddSiteIdToTempCalls < ActiveRecord::Migration
  def change
  	add_column :temp_calls, :site_id, :integer
  end
end
