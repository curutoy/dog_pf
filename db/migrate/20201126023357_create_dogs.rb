class CreateDogs < ActiveRecord::Migration[5.2]
  def change
    create_table :dogs do |t|
      t.string :name
      t.references :protector, foreign_key: true

      t.timestamps
    end
    add_index :dogs, [:protector_id, :created_at]
  end
end
