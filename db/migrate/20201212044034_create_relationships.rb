class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :protector_id
      t.integer :user_id

      t.timestamps

      t.index :protector_id
      t.index :user_id
      t.index [:protector_id, :user_id], unique: true
    end
  end
end
