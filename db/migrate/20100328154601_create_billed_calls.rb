class CreateBilledCalls < ActiveRecord::Migration
  def self.up
    create_table :billed_calls do |t|
      t.string :orig_tn
      t.string :date
      t.string :time
      t.integer :duration_sec
      t.string :destination
      t.string :term_tn
      t.string :code
      t.decimal :amount_charged, :precision => 8, :scale => 2
      t.integer :provider_id
      t.integer :bill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :billed_calls
  end
end
