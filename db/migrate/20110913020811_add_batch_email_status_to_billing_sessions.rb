class AddBatchEmailStatusToBillingSessions < ActiveRecord::Migration
  def self.up
    add_column :billing_sessions, :batch_email_status, :integer, :default => false
  end

  def self.down
    remove_column :billing_sessions, :batch_email_status
  end
end
