class AddSiteIdToSalesReps < ActiveRecord::Migration
  def change
  	add_column :sales_reps, :site_id, :integer
  end
end
