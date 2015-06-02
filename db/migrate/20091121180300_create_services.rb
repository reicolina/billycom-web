class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.integer :account_id
      t.string :type
      t.string :use
      t.decimal :rate, :precision => 8, :scale => 2
      t.date :port_date

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
