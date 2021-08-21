class CreateInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiries do |t|
      t.integer :user_id
      t.integer :application_id
      t.integer :inquirer_kind_id
      t.integer :inquiry_method_id
      t.integer :inquiry_classification_id
      t.integer :approver_id
      t.integer :inquiry_relation_id
      t.string :company_name
      t.string :inquirer_name
      t.string :telephone_number
      t.string :sub_telephone_number
      t.text :question
      t.text :answer
      t.boolean :is_completed
      t.date :inquiry_date
      t.date :start_time
      t.date :end_time
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
