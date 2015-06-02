class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.boolean :active
      t.string :account_number
      t.string :title
      t.string :address
      t.string :city
      t.string :province_or_state
      t.string :zip_or_postal_code
      t.string :billing_email
      t.string :main_contact_name
      t.string :main_contact_phone
      t.string :main_contact_fax
      t.string :main_contact_email
      t.integer :sales_rep_id

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
