class CreateApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :short_name
      t.timestamp :daleted_at
      t.timestamps
    end
  end
end
