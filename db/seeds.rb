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
  sub_breed_record = SubBreed.create(name: sub_breed, breed: breed_record, description: generate_dog_description)

  # Fetch and attach an image for each sub-breed
  begin
    sub_image_response = HTTParty.get("https://dog.ceo/api/breed/#{breed}/#{sub_breed}/images/random")
    sub_image_url = sub_image_response.parsed_response['message']

    # Attach the sub-breed image if it exists
    if sub_breed_record.persisted? && sub_image_url
      sub_image_file = HTTParty.get(sub_image_url)
      io = StringIO.new(sub_image_file.body)
      io.class.class_eval { attr_accessor :original_filename, :content_type }
      io.original_filename = "#{sub_breed}.jpg"
      io.content_type = 'image/jpg'

      # Resize and attach the image (similar to dogs)
      image = MiniMagick::Image.read(io)
      image.resize "300x300"
      resized_io = StringIO.new
      image.write(resized_io)
      resized_io.rewind

      # Attach the resized image to the sub-breed
      sub_breed_record.image.attach(io: resized_io, filename: io.original_filename, content_type: io.content_type)
      puts "Attached image for sub-breed: #{sub_breed_record.name}"
    else
      puts "No image URL found for sub-breed: #{sub_breed}"
    end
  rescue => e
    puts "Error processing image for sub-breed #{sub_breed}: #{e.message}"
  end

  sub_breed_record
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
      sub_breed_id: sub_breed_record&.id,
      description: generate_dog_description
    )

    # Attach image if the dog is persisted
    if dog.persisted?
      image_file = HTTParty.get(image_url)
      io = StringIO.new(image_file.body)
      io.class.class_eval { attr_accessor :original_filename, :content_type }
      io.original_filename = "#{dog.name}.jpg"
      io.content_type = 'image/jpg'

      # Resize the image using MiniMagick
      begin
        image = MiniMagick::Image.read(io)
        image.resize "300x300"
        resized_io = StringIO.new
        image.write(resized_io)
        resized_io.rewind

        # Attach the resized image to the dog
        dog.image.attach(io: resized_io, filename: io.original_filename, content_type: io.content_type)
      rescue => e
        puts "Error processing image for #{dog.name}: #{e.message}"
      end
    end
  end  
end
