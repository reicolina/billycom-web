class AddPrefixes1ToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :prefixes1, :string
  end

  def self.down
    remove_column :providers, :prefixes1
  end
end
