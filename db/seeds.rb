# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'httparty'

response = HTTParty.get('https://dog.ceo/api/breeds/list/all')
breeds = response.parsed_response['message']

breeds.each do |breed, _|
  new_breed = Breed.create!(name: breed)
  image_response = HTTParty.get("https://dog.ceo/api/breed/#{breed}/images/random/5")
  image_urls = image_response.parsed_response['message']

  image_urls.each do |url|
    Image.create!(url: url, breed: new_breed)
  end
end

