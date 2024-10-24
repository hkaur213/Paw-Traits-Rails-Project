class Dog < ApplicationRecord
  belongs_to :breed
  belongs_to :sub_breed, optional: true
  has_many :dog_traits
  has_many :traits, through: :dog_traits
  validates :name, :age, presence: true
end
