class CreateCallTypeInfos < ActiveRecord::Migration
  def self.up
    create_table :call_type_infos do |t|
      t.string :name
      t.string :abbreviation
      t.integer :call_type
      t.decimal :fixed_rate, :precision => 8, :scale => 2
      t.decimal :cdr_charge_factor, :precision => 8, :scale => 2
      t.boolean :is_calling_card

      t.timestamps
    end
  end

  def self.down
    drop_table :call_type_infos
  end
end
