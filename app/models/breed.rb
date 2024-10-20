class Breed < ApplicationRecord
    has_many :images
    validates :name, presence: true, uniqueness: true

  end
  