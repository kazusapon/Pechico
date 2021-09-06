class RenameApplicationIdColumnToInquiries < ActiveRecord::Migration[6.1]
  def change
    rename_column :inquiries, :application_id, :system_id
  end
end
