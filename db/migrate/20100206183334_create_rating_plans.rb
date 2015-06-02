class CreateRatingPlans < ActiveRecord::Migration
  def self.up
    create_table :rating_plans do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :rating_plans
  end
end
