class RenameInquirierKindIdToInquiries < ActiveRecord::Migration[6.1]
  def change
    rename_column :inquiries, :inquirer_kind_id, :inquirier_kind_id
  end
end
