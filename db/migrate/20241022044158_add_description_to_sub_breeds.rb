class AddDescriptionToSubBreeds < ActiveRecord::Migration[7.2]
  def change
    add_column :sub_breeds, :description, :string
  end
end
