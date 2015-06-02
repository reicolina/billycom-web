class AddLogo2XPositionToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :logo2_x_position, :integer
  end

  def self.down
    remove_column :sites, :logo2_x_position
  end
end
