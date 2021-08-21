class CreateInquiryClassifications < ActiveRecord::Migration[6.1]
  def change
    create_table :inquiry_classifications do |t|
      t.string :name
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
