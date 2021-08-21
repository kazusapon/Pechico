class CreateInquirerKinds < ActiveRecord::Migration[6.1]
  def change
    create_table :inquirer_kinds do |t|
      t.string :name
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
