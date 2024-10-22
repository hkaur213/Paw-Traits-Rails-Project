class SubBreedsController < ApplicationController
  def index
    @sub_breeds = SubBreed.all
  end

  def show
    @sub_breed = SubBreed.find(params[:id])
    # If you want to get the breed as well
    @breed = @sub_breed.breed
  end
end
