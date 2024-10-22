class ChangeSubBreedIdInDogsToBeNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_null :dogs, :sub_breed_id, true
  end
end
