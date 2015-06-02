class AddSiteIdToInternationalRates < ActiveRecord::Migration
  def change
  	add_column :international_rates, :site_id, :integer
  end
end
