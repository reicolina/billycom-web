class AddSiteIdToBilledServices < ActiveRecord::Migration
  def change
  	add_column :billed_services, :site_id, :integer
  end
end
