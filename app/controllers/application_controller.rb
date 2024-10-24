class ApplicationController < ActionController::Base
  before_action :load_breeds

  private

  def load_breeds
    api_response = HTTParty.get('https://dog.ceo/api/breeds/list/all')
    @breeds = api_response['message'] || {}
  end
end
