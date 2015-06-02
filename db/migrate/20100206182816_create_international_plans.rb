class CreateInternationalPlans < ActiveRecord::Migration
  def self.up
    create_table :international_plans do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :international_plans
  end
end
