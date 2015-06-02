class AddAmountChargedToTempCalls < ActiveRecord::Migration
  def self.up
    add_column :temp_calls, :amount_charged, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :temp_calls, :amount_charged
  end
end
