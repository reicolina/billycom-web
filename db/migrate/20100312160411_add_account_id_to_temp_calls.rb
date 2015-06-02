class AddAccountIdToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :account_id, :integer
  end

  def self.down
    remove_column :temp_calls, :account_id
  end
end
