class DropDogsTraits < ActiveRecord::Migration[7.0]
  def up
    drop_table :dogs_traits, if_exists: true
  end

  def down
    # Optional: Recreate the table in case of a rollback
    create_table :dogs_traits do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :trait, null: false, foreign_key: true
      t.timestamps
    end
  end
end
