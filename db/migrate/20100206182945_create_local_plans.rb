class CreateLocalPlans < ActiveRecord::Migration
  def self.up
    create_table :local_plans do |t|
      t.string :name
      t.decimal :rate, :precision => 8, :scale => 3

      t.timestamps
    end
  end

  def self.down
    drop_table :local_plans
  end
end
