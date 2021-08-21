class CreateCallHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :call_histroys do |t|
      t.integer :user_id
      t.string :company_name
      t.string :telephone_number
      t.date :inquiry_date
      t.time :start_time
      t.time :end_time
      t.timestamps
    end
  end
end
