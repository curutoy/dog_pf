class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|

      t.integer :visitor_protector_id
      t.integer :visited_protector_id
      t.integer :visitor_user_id
      t.integer :visited_user_id
      t.integer :dog_id
      t.integer :message_id
      t.string :action, default: '', null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end

    add_index :notifications, :visitor_protector_id
    add_index :notifications, :visited_protector_id
    add_index :notifications, :visitor_user_id
    add_index :notifications, :visited_user_id
    add_index :notifications, :dog_id
    add_index :notifications, :message_id
  end
end
