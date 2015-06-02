class AddSiteIdToBilledTaxes < ActiveRecord::Migration
  def change
  	add_column :billed_taxes, :site_id, :integer
  end
end
