class AddCallTypeAbbreviation1ToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :call_type_abbreviation1, :string
  end

  def self.down
    remove_column :providers, :call_type_abbreviation1
  end
end
