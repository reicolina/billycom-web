class CreateBilledServices < ActiveRecord::Migration
  def self.up
    create_table :billed_services do |t|
      t.string :type_of_service
      t.string :use
      t.decimal :amount_charged, :precision => 8, :scale => 2
      t.integer :bill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :billed_services
  end
end
