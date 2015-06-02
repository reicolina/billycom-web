class AddCallTypeToBilledCalls < ActiveRecord::Migration
  def self.up
    add_column :billed_calls, :call_type, :string
  end

  def self.down
    remove_column :billed_calls, :call_type
  end
end
