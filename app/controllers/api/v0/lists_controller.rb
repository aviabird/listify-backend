module Api::V0
  class ListsController <  ApiController

    def suggest
      list = List.all
      render json: list.as_json
    end    

  end
end