class AddCallTypeIndexToCallTypeInfos < ActiveRecord::Migration
  def self.up
    add_index(:call_type_infos, :call_type)
  end

  def self.down
    remove_index(:call_type_infos, :call_type)
  end
end
