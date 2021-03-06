class CreateBilledLines < ActiveRecord::Migration
  def self.up
    create_table :billed_lines do |t|
      t.string :number
      t.string :type_of_line
      t.string :use
      t.string :group
      t.string :sequence
      t.decimal :amount_charged, :precision => 8, :scale => 2
      t.integer :bill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :billed_lines
  end
end
