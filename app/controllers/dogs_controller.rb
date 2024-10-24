class DogsController < ApplicationController
  def index
    @dogs = Dog.includes(:breed, :sub_breed) # Eager load associations

    if params[:search].present?
      @dogs = @dogs.where("name LIKE ?", "%#{params[:search]}%")
    end

    if params[:breed_id].present?
      @dogs = @dogs.where(breed_id: params[:breed_id])
    end

    Rails.logger.debug "Querying Dogs: #{@dogs.to_sql}"
  end
end
