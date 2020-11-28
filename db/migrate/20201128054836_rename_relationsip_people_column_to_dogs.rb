class RenameRelationsipPeopleColumnToDogs < ActiveRecord::Migration[5.2]
  def change
    rename_column :dogs, :relationsip_people, :relationship_people
  end
end
