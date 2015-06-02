class CreateLines < ActiveRecord::Migration
  def self.up
    create_table :lines do |t|
      t.integer :account_id
      t.boolean :active
      t.string :number
      t.string :type
      t.string :use
      t.string :group
      t.integer :sequence
      t.decimal :line_rate, :precision => 8, :scale => 2
      t.decimal :local_ld_rate, :precision => 8, :scale => 2
      t.date :port_date

      t.timestamps
    end
  end

  def self.down
    drop_table :lines
  end
end
