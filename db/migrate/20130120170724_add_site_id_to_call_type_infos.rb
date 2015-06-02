class AddSiteIdToCallTypeInfos < ActiveRecord::Migration
  def change
  	add_column :call_type_infos, :site_id, :integer
  end
end
