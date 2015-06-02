class AddProcessingFlagToBillingSessions < ActiveRecord::Migration
  def change
  	add_column :billing_sessions, :processing_flag, :boolean, :default => false
  end
end
