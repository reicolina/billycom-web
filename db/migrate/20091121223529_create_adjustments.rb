class CreateAdjustments < ActiveRecord::Migration
  def self.up
    create_table :adjustments do |t|
      t.integer :account_id
      t.string :description
      t.decimal :amount, :precision => 8, :scale => 2
      t.date :apply_on

      t.timestamps
    end
  end

  def self.down
    drop_table :adjustments
  end
end
