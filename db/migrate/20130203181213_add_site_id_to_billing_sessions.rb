class AddSiteIdToBillingSessions < ActiveRecord::Migration
  def change
  	add_column :billing_sessions, :site_id, :integer
  end
end
