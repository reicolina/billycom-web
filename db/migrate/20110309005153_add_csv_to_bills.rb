class AddCsvToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :csv, :binary, :limit => 16.megabyte
  end

  def self.down
    remove_column :bills, :csv
  end
end
