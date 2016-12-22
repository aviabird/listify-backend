module Api::V0
  class ListsController <  ApiController

    def suggest
      lists = List.all.without(:member_ids);
      render json: lists.as_json
    end    
  end
end