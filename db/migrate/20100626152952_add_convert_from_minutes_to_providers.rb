class AddConvertFromMinutesToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :convert_from_minutes, :boolean
  end

  def self.down
    remove_column :providers, :convert_from_minutes
  end
end
