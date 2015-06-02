class RemoveLocalLdRateFromLine < ActiveRecord::Migration
  def self.up
    remove_column :lines, :local_ld_rate
  end

  def self.down
    add_column :lines, :local_ld_rate, :decimal, :precision => 8, :scale => 2
  end
end
