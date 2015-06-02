class AddLogo2YPositionToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :logo2_y_position, :integer
  end

  def self.down
    remove_column :sites, :logo2_y_position
  end
end
