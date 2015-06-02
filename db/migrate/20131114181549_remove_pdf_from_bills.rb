class RemovePdfFromBills < ActiveRecord::Migration
  def up
    remove_column :bills, :pdf
  end

  def down
    add_column :bills, :pdf, :binary
  end
end
