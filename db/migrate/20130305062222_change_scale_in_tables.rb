class ChangeScaleInTables < ActiveRecord::Migration
  def up
    change_column :billed_calls, :amount_charged, :decimal, :precision => 8, :scale => 4
    change_column :billed_taxes, :amount_charged, :decimal, :precision => 8, :scale => 4
    change_column :call_type_infos, :fixed_rate, :decimal, :precision => 8, :scale => 4
    change_column :international_rates, :rate, :decimal, :precision => 8, :scale => 4
    change_column :local_plans, :rate, :decimal, :precision => 8, :scale => 4
    change_column :minimum_charge_ratings, :fixed_minimum_charge, :decimal, :precision => 8, :scale => 4
    change_column :temp_calls, :amount_charged, :decimal, :precision => 8, :scale => 4
    change_column :temp_calls, :provider_charge, :decimal, :precision => 8, :scale => 4
  end

  def down
    change_column :billed_calls, :amount_charged, :decimal, :precision => 8, :scale => 2
    change_column :billed_taxes, :amount_charged, :decimal, :precision => 8, :scale => 2
    change_column :call_type_infos, :fixed_rate, :decimal, :precision => 8, :scale => 2
    change_column :international_rates, :rate, :decimal, :precision => 8, :scale => 3
    change_column :local_plans, :rate, :decimal, :precision => 8, :scale => 3
    change_column :minimum_charge_ratings, :fixed_minimum_charge, :decimal, :precision => 8, :scale => 2
    change_column :temp_calls, :amount_charged, :decimal, :precision => 8, :scale => 2
    change_column :temp_calls, :provider_charge, :decimal, :precision => 8, :scale => 2
  end
end
