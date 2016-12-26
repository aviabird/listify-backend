module Api::V0
  class BikesController < ApiController

    def all_bikes
      bikes = Bike.all
      render json: bikes
    end

  end
end