class SubBreed < ApplicationRecord
  belongs_to :breed
  has_many :dogs
  validates :name, presence: true
  validates :breed_id, presence: true
end
