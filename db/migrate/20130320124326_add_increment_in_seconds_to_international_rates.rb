class AddIncrementInSecondsToInternationalRates < ActiveRecord::Migration
  def change
    add_column :international_rates, :increment_in_seconds, :integer, :default => 1
  end
end
