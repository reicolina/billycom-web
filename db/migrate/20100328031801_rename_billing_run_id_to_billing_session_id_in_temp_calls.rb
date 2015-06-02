class RenameBillingRunIdToBillingSessionIdInTempCalls < ActiveRecord::Migration
  def self.up
    change_table :temp_calls do |t|
      t.rename :billing_run_id, :billing_session_id
    end
  end

  def self.down
    change_table :temp_calls do |t|
      t.rename :billing_session_id, :billing_run_id
    end
  end
end
