class RemoveColumnStartTimeAndEndTimeFromInquiries < ActiveRecord::Migration[6.1]
  def change
    remove_column :inquiries, :start_time
    remove_column :inquiries, :end_time 
  end
end
