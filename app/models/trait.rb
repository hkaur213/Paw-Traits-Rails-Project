class Trait < ApplicationRecord
  has_many :dog_traits, dependent: :destroy
  has_many :dogs, through: :dog_traits

  validates :name, presence: true
end
