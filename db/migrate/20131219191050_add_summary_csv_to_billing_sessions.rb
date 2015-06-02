class AddSummaryCsvToBillingSessions < ActiveRecord::Migration
  def change
  	add_column :billing_sessions, :csv, :string, :default => ''
  end
end
