class AddCsvPathToBills < ActiveRecord::Migration
  def change
    add_column :bills, :csv, :string, :default => ''
  end
end
