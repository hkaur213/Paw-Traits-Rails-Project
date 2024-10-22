class Image < ApplicationRecord
  belongs_to :breed
  belongs_to :dog
  validates :url, presence: true

end
