class CreateCommonInquiries < ActiveRecord::Migration[6.1]
  def change
    create_table :common_inquiries do |t|
      t.integer :system_id
      t.text :question
      t.text :answer
      t.integer :sort_order
      t.timestamps
    end
  end
end
