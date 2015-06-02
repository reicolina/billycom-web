class AddSiteIdToBilledLines < ActiveRecord::Migration
  def change
  	add_column :billed_lines, :site_id, :integer
  end
end
