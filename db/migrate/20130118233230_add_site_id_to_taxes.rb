class AddSiteIdToTaxes < ActiveRecord::Migration
  def change
    add_column :taxes, :site_id, :integer
  end
end
