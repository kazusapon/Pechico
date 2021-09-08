class ChangeInquirerKindsToInquirierKinds < ActiveRecord::Migration[6.1]
  def change
    rename_table :inquirer_kinds, :inquirier_kinds
  end
end
