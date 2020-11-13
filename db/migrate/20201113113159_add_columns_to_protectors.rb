class AddColumnsToProtectors < ActiveRecord::Migration[5.2]
  def change
    add_column :protectors, :name,    :string
    add_column :protectors, :address, :integer
    add_column :protectors, :url,     :string
    add_column :protectors, :profile, :text
  end
end
