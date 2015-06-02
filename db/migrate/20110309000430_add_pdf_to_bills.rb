class AddPdfToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :pdf, :binary, :limit => 16.megabyte
  end

  def self.down
    remove_column :bills, :pdf
  end
end
