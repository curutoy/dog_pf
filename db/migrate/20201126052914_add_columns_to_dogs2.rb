class AddColumnsToDogs2 < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :castration, :integer
    add_column :dogs, :vaccine, :integer
    add_column :dogs, :microchip, :integer
    add_column :dogs, :conditions, :text
    add_column :dogs, :single_person, :integer
    add_column :dogs, :senior, :integer
  end
end
