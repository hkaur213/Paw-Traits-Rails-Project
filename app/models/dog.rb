class Dog < ApplicationRecord
  belongs_to :breed
  belongs_to :sub_breed, optional: true
  has_one_attached :image
  validates :name, presence: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end