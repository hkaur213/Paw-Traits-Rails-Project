class RenameDogsTraitsToDogTraits < ActiveRecord::Migration[7.0]
  def change
    rename_table :dogs_traits, :dog_traits
  end
end
