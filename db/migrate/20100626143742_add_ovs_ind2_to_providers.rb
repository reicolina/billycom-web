class AddOvsInd2ToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :ovs_ind2, :integer
  end

  def self.down
    remove_column :providers, :ovs_ind2
  end
end
