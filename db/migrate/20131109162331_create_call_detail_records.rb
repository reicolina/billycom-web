class CreateCallDetailRecords < ActiveRecord::Migration
  def change
    create_table :call_detail_records do |t|
      t.string :name
      t.integer :provider_id
      t.integer :site_id

      t.timestamps
    end
  end
end
