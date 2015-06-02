class AddFailedToBillingSessions < ActiveRecord::Migration
  def change
  	add_column :billing_sessions, :failed, :boolean, :default => false
  end
end
