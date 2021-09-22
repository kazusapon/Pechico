class AddColumnStartTimeAndEndTimeFromInquiries < ActiveRecord::Migration[6.1]
  def change
    add_column :inquiries, :start_time, :time
    add_column :inquiries, :end_time, :time
  end
end
