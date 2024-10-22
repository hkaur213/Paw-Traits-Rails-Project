require 'httparty'
require 'faker'
require 'stringio'
require 'mini_magick'

# Method to generate a random dog description
def generate_dog_description
  sentences = [
    "The #{Faker::Creature::Dog.breed} is known for its friendly and playful nature.",
    "This breed is a great companion and loves spending time with its family.",
    "With a lifespan of around #{rand(10..15)} years, they are sure to bring joy for many years.",
    "They require regular exercise and enjoy activities like walking, running, and playing fetch.",
    "These dogs are often very loyal and protective of their owners.",
    "Their beautiful coat comes in various colors and patterns, making them quite unique."
  ]
  
  sentences.sample(rand(3..4)).join(' ') # Randomly select 3-4 sentences and join them
end

# Fetch breeds and sub-breeds from Dog CEO API
breed_data = HTTParty.get('https://dog.ceo/api/breeds/list/all')
breeds = breed_data.parsed_response['message']

breeds.each do |breed, sub_breeds|
  # Create the main breed record
  breed_record = Breed.create(name: breed)

  # Create sub-breed records and store them in an array
  sub_breed_records = sub_breeds.map do |sub_breed|
    SubBreed.create(name: sub_breed, breed: breed_record)
  end

  # Seed dogs with images and descriptions
  10.times do
    image_response = HTTParty.get("https://dog.ceo/api/breed/#{breed}/images/random")
    image_url = image_response.parsed_response['message']

    # Randomly select a sub-breed if any exist
    sub_breed_record = sub_breed_records.sample

    dog = Dog.create(
      name: Faker::Creature::Dog.name,
      age: rand(1..15),
      breed_id: breed_record.id,
      sub_breed_id: sub_breed_record&.id, # This will be nil if no sub-breed is selected
      image_url: image_url,                # Add the image URL here
      description: generate_dog_description # Add a fake multi-sentence description
    )

    # Attach image if the dog is persisted
    if dog.persisted?
      image_file = HTTParty.get(image_url) # Fetch the image
      io = StringIO.new(image_file.body)    # Wrap the body in a StringIO object
      io.class.class_eval { attr_accessor :original_filename, :content_type } # Add attributes
      io.original_filename = "#{dog.name}.jpg"
      io.content_type = 'image/jpg'

      # Resize the image using MiniMagick
      begin
        image = MiniMagick::Image.read(io)
        image.resize "300x300" # Set your desired size here (e.g., 300x300)
        resized_io = StringIO.new
        image.write(resized_io) # Write resized image to StringIO
        resized_io.rewind # Rewind the IO

        # Attach the resized image
        dog.image.attach(io: resized_io, filename: io.original_filename, content_type: io.content_type)
      rescue => e
        puts "Error processing image for #{dog.name}: #{e.message}"
      end
    end
  end  
end
