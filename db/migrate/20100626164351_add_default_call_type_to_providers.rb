class AddDefaultCallTypeToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :default_call_type, :string
  end

  def self.down
    remove_column :providers, :default_call_type
  end
end
