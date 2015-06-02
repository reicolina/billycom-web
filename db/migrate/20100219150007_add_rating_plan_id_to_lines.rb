class AddRatingPlanIdToLines < ActiveRecord::Migration
  def self.up
    add_column :lines, :rating_plan_id, :integer
  end

  def self.down
    remove_column :lines, :rating_plan_id
  end
end
