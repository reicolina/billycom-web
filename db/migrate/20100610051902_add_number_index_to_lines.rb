class AddNumberIndexToLines < ActiveRecord::Migration
  def self.up
    add_index(:lines, :number)
  end

  def self.down
    remove_index("`lines`", :name => "index_lines_on_number")
  end
end
