class AddAbbreviationIndexToCallTypeInfos < ActiveRecord::Migration
  def self.up
    add_index(:call_type_infos, :abbreviation, :unique => true)
  end

  def self.down
    remove_index(:call_type_infos, :abbreviation)
  end
end
