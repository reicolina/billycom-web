class AddTermTn1ToProviders < ActiveRecord::Migration
  def self.up
    add_column :providers, :term_tn1, :integer
  end

  def self.down
    remove_column :providers, :term_tn1
  end
end
