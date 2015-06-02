class AddStatusToBillingSessions < ActiveRecord::Migration
  def change
    add_column :billing_sessions, :status, :string
  end
end
