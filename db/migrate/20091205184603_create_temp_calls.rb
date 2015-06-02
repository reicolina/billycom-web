class CreateTempCalls < ActiveRecord::Migration
  def self.up
    create_table :temp_calls do |t|
      t.string :orig_tn
      t.string :date
      t.string :time
      t.integer :duration_sec
      t.string :destination
      t.string :cc_ind
      t.string :ovs_ind
      t.string :term_tn
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :temp_calls
  end
end
