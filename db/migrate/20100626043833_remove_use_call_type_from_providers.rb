class RemoveUseCallTypeFromProviders < ActiveRecord::Migration
  def self.up
    remove_column :providers, :use_call_type
  end

  def self.down
    add_column :providers, :use_call_type, :boolean
  end
end
