class AddCallTypeToInternationalRates < ActiveRecord::Migration
  def self.up
    add_column :international_rates, :call_type, :integer
  end

  def self.down
    remove_column :international_rates, :call_type
  end
end
