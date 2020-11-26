class RenameSinglePersonToDogs < ActiveRecord::Migration[5.2]
  def change
    rename_column :dogs, :single_person, :single_people
  end
end
