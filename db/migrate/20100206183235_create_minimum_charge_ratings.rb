class CreateMinimumChargeRatings < ActiveRecord::Migration
  def self.up
    create_table :minimum_charge_ratings do |t|
      t.string :name
      t.decimal :duration_sec
      t.decimal :percentage, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :minimum_charge_ratings
  end
end
