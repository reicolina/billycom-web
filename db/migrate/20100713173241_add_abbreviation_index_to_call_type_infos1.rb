class AddAbbreviationIndexToCallTypeInfos1 < ActiveRecord::Migration
  def self.up
    add_index(:call_type_infos, :abbreviation)
  end

  def self.down
    remove_index(:call_type_infos, :abbreviation)
  end
end
