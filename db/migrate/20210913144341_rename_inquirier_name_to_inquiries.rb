class RenameInquirierNameToInquiries < ActiveRecord::Migration[6.1]
  def change
    rename_column :inquiries, :inquirer_name, :inquirier_name
  end
end
