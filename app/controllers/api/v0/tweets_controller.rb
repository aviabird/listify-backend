module Api::V0
  class Api::V0::TweetsController < ApiController
    before_action :authenticate_user!    

    def add_tweet_to_fav
      tweet = params["feed"];
      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]
      service_params = { access_token: access_token, secret_token: secret_token}
      @tweet_service = TwitterApi::TweetService.new(params: service_params)
      result = @tweet_service.add_to_fav(tweet);
      render json: result
    end

    def remove_tweet_from_fav
      tweet = params["feed"];
      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]
      service_params = { access_token: access_token, secret_token: secret_token}
      @tweet_service = TwitterApi::TweetService.new(params: service_params)
      result = @tweet_service.remove_tweet_from_fav(tweet);
      render json: result
    end

    def retweet
      tweet = params["feed"];
      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]
      service_params = { access_token: access_token, secret_token: secret_token}
      @tweet_service = TwitterApi::TweetService.new(params: service_params)
      result = @tweet_service.retweet(tweet);
      render json: result
    end

    def reply
      tweet = params["feed"]
      msg = params["message"]
      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]
      service_params = { access_token: access_token, secret_token: secret_token}
      @tweet_service = TwitterApi::TweetService.new(params: service_params)
      result = @tweet_service.reply(tweet, msg)
      render json: result
    end
  end
end
