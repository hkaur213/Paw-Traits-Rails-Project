class Image < ApplicationRecord
  belongs_to :breed
  validates :url, presence: true

end
