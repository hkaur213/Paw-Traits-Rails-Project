class DogsController < ApplicationController
  def index
    if params[:search].present? || params[:breed_id].present?
      @dogs = Dog.all

      if params[:search].present?
        @dogs = @dogs.where('name LIKE ?', "%#{params[:search]}%")
      end
      
      if params[:breed_id].present? && params[:breed_id].to_i.positive?
        @dogs = @dogs.where(breed_id: params[:breed_id])
      end
    else
      @dogs = Dog.all
    end
  end
end
