class CreateBillingSessions < ActiveRecord::Migration
  def self.up
    create_table :billing_sessions do |t|
      t.string :name
      t.date :billing_date
      t.date :due_date
      t.integer :start_number
      t.boolean :pending_flag

      t.timestamps
    end
  end

  def self.down
    drop_table :billing_sessions
  end
end
