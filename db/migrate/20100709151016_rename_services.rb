class RenameServices < ActiveRecord::Migration
  def self.up
    rename_table :services, :other_services
  end

  def self.down
    rename_table :other_services, :services
  end
end
