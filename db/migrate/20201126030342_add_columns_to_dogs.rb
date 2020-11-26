class AddColumnsToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :age, :integer
    add_column :dogs, :address, :integer
    add_column :dogs, :gender, :integer
    add_column :dogs, :size, :integer
    add_column :dogs, :profile, :text
    add_column :dogs, :walking, :integer
    add_column :dogs, :caretaker, :integer
    add_column :dogs, :relationsip_dog, :integer
    add_column :dogs, :relationsip_people, :integer
  end
end
