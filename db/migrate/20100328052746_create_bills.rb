class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.integer :number
      t.integer :account_id
      t.integer :billing_session_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
