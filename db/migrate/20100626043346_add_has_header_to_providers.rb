class AddHasHeaderToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :has_header, :boolean
  end

  def self.down
    remove_column :providers, :has_header
  end
end
