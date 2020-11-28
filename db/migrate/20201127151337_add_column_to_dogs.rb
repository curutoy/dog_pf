class AddColumnToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :health, :text
  end
end
