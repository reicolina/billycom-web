class AddSiteIdToBilledAdjustments < ActiveRecord::Migration
  def change
  	add_column :billed_adjustments, :site_id, :integer
  end
end
