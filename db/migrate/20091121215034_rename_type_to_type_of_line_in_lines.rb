class RenameTypeToTypeOfLineInLines < ActiveRecord::Migration
  def self.up
    change_table :lines do |t|
      t.rename :type, :type_of_line
    end
  end

  def self.down
    change_table :lines do |t|
      t.rename :type_of_line, :type
    end
  end
end
