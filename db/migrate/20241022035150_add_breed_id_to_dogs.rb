class AddBreedIdToDogs < ActiveRecord::Migration[7.2]
  def change
    add_column :dogs, :breed_id, :integer
  end
end
