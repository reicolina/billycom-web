class AddIncrementInSecondsToLocalPlans < ActiveRecord::Migration
  def change
    add_column :local_plans, :increment_in_seconds, :integer, :default => 1
  end
end
