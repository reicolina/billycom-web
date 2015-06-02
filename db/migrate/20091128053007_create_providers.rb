class CreateProviders < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      t.string :name
      t.integer :orig_tn
      t.integer :date
      t.integer :time
      t.integer :duration_sec
      t.integer :destination
      t.integer :cc_ind
      t.integer :ovs_ind
      t.integer :term_tn
      t.integer :code

      t.timestamps
    end
  end

  def self.down
    drop_table :providers
  end
end
