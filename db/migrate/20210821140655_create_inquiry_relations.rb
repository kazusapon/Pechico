class CreateInquiryRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiry_relations do |t|
      t.integer :inquiry_id
      t.timestamps
    end
  end
end
