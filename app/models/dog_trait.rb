class DogTrait < ApplicationRecord
  belongs_to :dog
  belongs_to :trait

  validates :dog_id, presence: true
  validates :trait_id, presence: true
end
