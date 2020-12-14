class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :dog_id

      t.timestamps

      t.index :user_id
      t.index :dog_id
      t.index [:user_id, :dog_id], unique: true
    end
  end
end
