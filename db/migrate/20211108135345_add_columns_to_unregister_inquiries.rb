class AddColumnsToUnregisterInquiries < ActiveRecord::Migration[6.1]
  def change
    add_column :unregister_inquiries, :inquirier_name, :string
    add_column :unregister_inquiries, :inquirer_kind_id, :integer
    add_column :unregister_inquiries, :unknown_number_status, :integer
  end
end
