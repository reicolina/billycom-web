class CreateCallDetailRecordsAndBillingSessions < ActiveRecord::Migration
  def up
  	  create_table :billing_sessions_call_detail_records do |t|
      t.belongs_to :billing_session
      t.belongs_to :call_detail_record
    end
  end

  def down
  	drop_table :billing_sessions_call_detail_records
  end
end
