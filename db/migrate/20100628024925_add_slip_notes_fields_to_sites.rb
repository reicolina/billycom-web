class AddSlipNotesFieldsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :slip_notes_line_1, :string
    add_column :sites, :slip_notes_line_2, :string
    add_column :sites, :slip_notes_line_3, :string
    add_column :sites, :slip_notes_line_4, :string
  end

  def self.down
    remove_column :sites, :slip_notes_line_1
    remove_column :sites, :slip_notes_line_2
    remove_column :sites, :slip_notes_line_3
    remove_column :sites, :slip_notes_line_4
  end
end
