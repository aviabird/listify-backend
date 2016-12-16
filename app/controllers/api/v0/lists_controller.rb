module Api::V0
  class ListsController <  ApiController

    def suggest
      list = List.all.includes(:members);
      render json: list.as_json(include: :members);
    end
    
  end
end