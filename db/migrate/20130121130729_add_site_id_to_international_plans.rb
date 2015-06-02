class AddSiteIdToInternationalPlans < ActiveRecord::Migration
  def change
  	add_column :international_plans, :site_id, :integer
  end
end
