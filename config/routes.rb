require 'api_constraint'
Rails.application.routes.draw do
  devise_for :users
  # => For details on the DSL available within this file, 
  # => see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: 'json'} do
    scope module: :v0, constraints: ApiConstraint.new(version: 0, default: true) do
      match 'auth/twitter', to: 'auth#twitter', via: [:get,:post]
      post '/twitter_step_2', to: 'auth#twitter_step_2'
      post 'auth/sign_in', to: 'auth#sign_in'
      post 'auth/sign_up', to: 'auth#sign_up'
      post 'lists/suggest', to: 'lists#suggest'
      post 'users/create_list', to: 'users#create_list'
      post 'users/unfollow_list', to: 'users#unfollow_list'
      post 'users/list_timeline', to: 'users#list_timeline'
      post 'users/user_list', to: 'users#user_list'
      post 'users/user_detail', to: 'users#user_detail'
      post 'users/all_feeds', to: 'users#all_feeds'
      post 'tweets/add_tweet_to_fav', to: 'tweets#add_tweet_to_fav'
      post 'tweets/remove_tweet_from_fav', to: 'tweets#remove_tweet_from_fav'
    end
  end
end
