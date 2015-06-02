class AddSiteIdToBilledCalls < ActiveRecord::Migration
  def change
  	add_column :billed_calls, :site_id, :integer
  end
end
