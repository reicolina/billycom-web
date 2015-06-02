class AddCallTypeAbbreviationToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :call_type_abbreviation, :string
  end

  def self.down
    remove_column :providers, :call_type_abbreviation
  end
end
