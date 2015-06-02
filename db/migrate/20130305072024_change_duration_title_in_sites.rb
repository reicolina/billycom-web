class ChangeDurationTitleInSites < ActiveRecord::Migration
  def up
    change_column :sites, :duration_title, :string, :default=>'Dur(hh:mm:ss)'
  end

  def down
    change_column :sites, :duration_title, :string, :default=>'Duration(min.)'
  end
end
