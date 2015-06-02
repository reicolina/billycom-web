class AddSiteIdToLocalPlans < ActiveRecord::Migration
  def change
  	add_column :local_plans, :site_id, :integer
  end
end
