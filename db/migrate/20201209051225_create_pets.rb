class CreatePets < ActiveRecord::Migration[5.2]
  def change
    create_table :pets do |t|
      t.integer :age
      t.integer :gender
      t.string :character
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :pets, [:user_id, :created_at]
  end
end
