# TwitterApi::RetriveUserDetail.call(user)
module TwitterApi
  class RetriveUserDetail < TwitterApi::Base
    
    def call
      begin
        @result = {status: false}
        user_detail = @client.user.to_hash
        @result[:user_detail] = user_detail
        @result[:status] = true
        @result
      rescue => e
        @result[:error] = e.inspect
        puts e.backtrace
      ensure
        return @result
      end
    end
  end
end