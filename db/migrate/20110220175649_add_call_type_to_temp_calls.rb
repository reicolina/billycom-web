class AddCallTypeToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :call_type, :string
  end

  def self.down
    remove_column :temp_calls, :call_type
  end
end
