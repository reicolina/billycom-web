class CreateBilledTaxes < ActiveRecord::Migration
  def self.up
    create_table :billed_taxes do |t|
      t.string :name
      t.decimal :rate, :precision => 8, :scale => 2
      t.decimal :amount_charged, :precision => 8, :scale => 2
      t.integer :bill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :billed_taxes
  end
end
