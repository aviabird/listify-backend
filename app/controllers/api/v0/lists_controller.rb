module Api::V0
  class ListsController <  ApiController
    before_action :authenticate_user!

    # def user_info
    #   params = { access_token: current_user.access_tokens[:twitter], 
    #             secret_token:  current_user.secret_tokens[:twitter] }
    #   @client = Twitter::REST::Client.new do |config|
    #     config.consumer_key        = "TSOSvmRILlXHXeci9WJPFwmEX"
    #     config.consumer_secret     = "5hoSZ6AkGnJ3u6UCicBnTK66lWkK36NYDa1Bm4LwAw4r1P0JBL"
    #     config.access_token        = params[:access_token]
    #     config.access_token_secret = params[:secret_token]
    #   end      
    #   tweeits = @client
    # end

    def create
      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "TSOSvmRILlXHXeci9WJPFwmEX"
        config.consumer_secret     = "5hoSZ6AkGnJ3u6UCicBnTK66lWkK36NYDa1Bm4LwAw4r1P0JBL"
        config.access_token        = access_token
        config.access_token_secret = secret_token
      end
      list_name = params["name"]
      usernames = params["usernames"]

      list = @client.create_list(list_name)
      @client.add_list_members(list, usernames)
      list_attr = { user_id: current_user.id, 
                  twitter_list_id: list.id, 
                  name: list.name,
                  description: list.description.to_s,
                  mode: list.mode}

      listy = List.new(list_attr)
      listy.save

      # Members
      members = @client.list_members(list)
      # iiterate
      members.attrs[:users].each do |lmname|
        mem_attr = {}
        mem_attr[:twitter_id] = lmname[:id]
        mem_attr[:screen_name] = lmname[:screen_name]
        mem_attr[:uri] = lmname[:url]
        mem_attr[:list_id] = listy.id
        new_member = Member.new(mem_attr)
        new_member.save
      end
      return true
    end
  end
end