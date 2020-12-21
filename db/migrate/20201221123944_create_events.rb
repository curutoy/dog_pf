class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :protector_id
      t.date :due_on
      t.time :start_at
      t.time :finish_at
      t.integer :prefecture
      t.string :address
      t.float :latitude
      t.float :longitude
      t.text :content

      t.timestamps

      t.index :protector_id
      t.index :due_on
      t.index :address
    end
  end
end
