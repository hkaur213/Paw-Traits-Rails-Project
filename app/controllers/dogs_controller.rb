class DogsController < ApplicationController
    def index
      @dogs = Dog.includes(:traits).all
    end
  end
  