class RenameRelationsipDogColumnToDogs < ActiveRecord::Migration[5.2]
  def change
    rename_column :dogs, :relationsip_dog, :relationship_dog
  end
end
