class CreateBilledAdjustments < ActiveRecord::Migration
  def self.up
    create_table :billed_adjustments do |t|
      t.string :description
      t.decimal :amount_charged, :precision => 8, :scale => 2
      t.integer :bill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :billed_adjustments
  end
end
