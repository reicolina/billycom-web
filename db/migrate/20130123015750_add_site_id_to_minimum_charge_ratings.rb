class AddSiteIdToMinimumChargeRatings < ActiveRecord::Migration
  def change
  	add_column :minimum_charge_ratings, :site_id, :integer
  end
end
