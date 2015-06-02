class AddSiteIdToProviders < ActiveRecord::Migration
  def change
  	add_column :providers, :site_id, :integer
  end
end
