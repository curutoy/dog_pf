class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name,          :string
    add_column :users, :address,       :integer
    add_column :users, :family_people, :integer
    add_column :users, :house,         :integer
    add_column :users, :caretaker,     :integer
    add_column :users, :profile,       :text
  end
end
