class AddPrefixesToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :prefixes, :string
  end

  def self.down
    remove_column :providers, :prefixes
  end
end
