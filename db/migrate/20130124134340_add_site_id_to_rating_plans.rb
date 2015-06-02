class AddSiteIdToRatingPlans < ActiveRecord::Migration
  def change
  	add_column :rating_plans, :site_id, :integer
  end
end
