class AddPdfPathToBills < ActiveRecord::Migration
  def change
    add_column :bills, :pdf, :string, :default => ''
  end
end
