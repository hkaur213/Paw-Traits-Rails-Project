class BreedsController < ApplicationController
  def index
    @breeds = HTTParty.get('https://dog.ceo/api/breeds/list/all')['message']
    @breed_images = {}

    @breeds.each_key do |breed|
      image_response = HTTParty.get("https://dog.ceo/api/breed/#{breed}/images/random")
      @breed_images[breed] = image_response['message']
    end

    # Paginate the breeds' keys
    @paginated_breeds = Kaminari.paginate_array(@breeds.keys).page(params[:page]).per(8)
    @current_page = params[:page].to_i > 0 ? params[:page].to_i : 1
  end
end
