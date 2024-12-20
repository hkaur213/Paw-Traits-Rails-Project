require 'httparty'
require 'faker'

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
  
  sentences.sample(rand(3..4)).join(' ') 
end

# Fetch breeds and sub-breeds from Dog CEO API
breed_data = HTTParty.get('https://dog.ceo/api/breeds/list/all')
breeds = breed_data.parsed_response['message']

breeds.each do |breed, sub_breeds|
  # Create or find the main breed record
  breed_record = Breed.find_or_create_by(name: breed) do |b|
    puts "Creating breed: #{breed}"
  end

  # Ensure breed was created successfully
  if breed_record.persisted?
    puts "Successfully created or found breed: #{breed_record.name}"

    # Create sub-breed records and store them in an array
    sub_breed_records = []
    
    sub_breeds.each do |sub_breed|
      description = generate_dog_description 
      sub_breed_record = SubBreed.find_or_create_by(name: sub_breed, breed: breed_record) do |sb|
        sb.description = description
        puts "Creating sub-breed: #{sub_breed} for breed: #{breed} with description: #{description}"
      end

      # Always update the description to ensure it's available for each sub-breed
      if sub_breed_record.persisted?
        sub_breed_record.update(description: description) if sub_breed_record.description.blank?
        puts "Successfully created sub-breed: #{sub_breed_record.name} with description: #{sub_breed_record.description}"
      else
        puts "Failed to create sub-breed: #{sub_breed_record.name}. Errors: #{sub_breed_record.errors.full_messages.join(', ')}"
      end

      sub_breed_records << sub_breed_record
    end

    # Seed dogs with descriptions
    10.times do
      # Randomly select a sub-breed if any exist
      sub_breed_record = sub_breed_records.sample

      dog = Dog.create(
        name: Faker::Creature::Dog.name,
        age: rand(1..15),
        breed_id: breed_record.id,
        sub_breed_id: sub_breed_record&.id,
        description: generate_dog_description
      )

      # Associate random traits with the dog
      if dog.persisted?
        traits = ['Friendly', 'Playful', 'Loyal', 'Energetic', 'Protective', 'Calm']

        # Create some traits if they don't exist
        traits.each do |trait_name|
          Trait.find_or_create_by(name: trait_name) do |trait|
            puts "Creating trait: #{trait_name}" if trait.persisted?
          end
        end

        # Now associate random traits with each dog
        begin
          selected_traits = Trait.order("RANDOM()").limit(rand(1..3)).pluck(:id)  # Get 1 to 3 random traits
          selected_traits.each do |trait_id|
            DogTrait.create!(dog_id: dog.id, trait_id: trait_id)
            puts "Associated trait with dog: #{dog.name} - Trait ID: #{trait_id}"
          end
        rescue => e
          puts "Error associating trait with dog #{dog.name}: #{e.message}"
        end

      else
        puts "Failed to create dog: #{dog.name}. Errors: #{dog.errors.full_messages.join(', ')}"
      end
    end  
  else
    puts "Failed to create or find breed: #{breed}. Errors: #{breed_record.errors.full_messages.join(', ')}"
  end
end 
