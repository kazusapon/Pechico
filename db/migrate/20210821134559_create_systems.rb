class CreateSystems < ActiveRecord::Migration[6.1]
  def change
    create_table :systems do |t|
      t.string :name
      t.string :short_name
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
