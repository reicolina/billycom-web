class AddCdrToCallDetailRecords < ActiveRecord::Migration
  def change
    add_column :call_detail_records, :cdr, :string
  end
end
