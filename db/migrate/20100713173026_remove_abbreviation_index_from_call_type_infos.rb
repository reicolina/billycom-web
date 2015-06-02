class RemoveAbbreviationIndexFromCallTypeInfos < ActiveRecord::Migration
  def self.up
    remove_index(:call_type_infos, :abbreviation)
  end

  def self.down
    add_index(:call_type_infos, :abbreviation, :unique => true)
  end
end
