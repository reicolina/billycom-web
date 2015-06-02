class RemoveCsvFromBills < ActiveRecord::Migration
  def up
    remove_column :bills, :csv
  end

  def down
    add_column :bills, :csv, :binary
  end
end
