class SubBreed < ApplicationRecord
  belongs_to :breed
  has_many :dogs
  has_one_attached :image
  validates :name, presence: true
  validates :breed_id, presence: true
end
