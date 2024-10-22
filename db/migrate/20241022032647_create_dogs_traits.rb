class CreateDogsTraits < ActiveRecord::Migration[7.2]
  def change
    create_table :dogs_traits do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :trait, null: false, foreign_key: true

      t.timestamps
    end
  end
end
