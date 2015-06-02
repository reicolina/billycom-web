class AddUseCallTypeToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :use_call_type, :boolean
  end

  def self.down
    remove_column :providers, :use_call_type
  end
end
