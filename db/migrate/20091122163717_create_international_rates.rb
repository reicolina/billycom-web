class CreateInternationalRates < ActiveRecord::Migration
  def self.up
    create_table :international_rates do |t|
      t.string :code
      t.string :destination
      t.decimal :rate, :precision => 8, :scale => 3

      t.timestamps
    end
  end

  def self.down
    drop_table :international_rates
  end
end
