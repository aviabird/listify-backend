module Api::V0
  class ListsController <  ApiController
    before_action :authenticate_user!
    def suggest
      user_lists = current_user.users_lists.all
      modified_lists = followed_unfollowed_lists(user_lists);
      render json: modified_lists.as_json
    end
    
    private
      def followed_unfollowed_lists(user_list)
        followed_list_ids = user_list.map {|ul| ul.list_id}

        followed_lists = List.find(followed_list_ids)
                            .as_json
                            .map {|li| li.merge(isFollowing: true)}
        
        not_followed_lists = List.not_in(_id: followed_list_ids)
                                .as_json
                                .map {|li| li.merge(isFollowing: false)}
        modified_lists = followed_lists + not_followed_lists
        return modified_lists
      end
  end
end