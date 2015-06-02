class RenameTypeToTypeOfServiceInServices < ActiveRecord::Migration
  def self.up
    change_table :services do |t|
      t.rename :type, :type_of_service
    end
  end

  def self.down
    change_table :services do |t|
      t.rename :type_of_service, :type
    end
  end
end
