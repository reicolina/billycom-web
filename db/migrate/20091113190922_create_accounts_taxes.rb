class CreateAccountsTaxes < ActiveRecord::Migration
  def self.up
    create_table :accounts_taxes, :id => false do |t|
      t.integer :account_id
      t.integer :tax_id
  end

  def self.down
    drop_table :accounts_taxes
  end
  end
end
