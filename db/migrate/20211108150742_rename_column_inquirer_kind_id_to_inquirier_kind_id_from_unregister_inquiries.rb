class RenameColumnInquirerKindIdToInquirierKindIdFromUnregisterInquiries < ActiveRecord::Migration[6.1]
  def change
    rename_column :unregister_inquiries, :inquirer_kind_id, :inquirier_kind_id
  end
end
