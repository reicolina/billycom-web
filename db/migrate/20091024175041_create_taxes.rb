class CreateTaxes < ActiveRecord::Migration
  def self.up
    create_table :taxes do |t|
      t.string :name
      t.decimal :rate, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :taxes
  end
end
