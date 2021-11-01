class AddColumnApproveAtToInquiries < ActiveRecord::Migration[6.1]
  def change
    add_column :inquiries, :approve_at, :timestamp
  end
end
