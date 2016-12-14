require 'api_constraint'
Rails.application.routes.draw do
  devise_for :users
  # => For details on the DSL available within this file, 
  # => see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: 'json'} do
    scope module: :v0, constraints: ApiConstraint.new(version: 0, default: true) do
      # resources :users
      # post 'auth/:provider', to: 'auth#authenticate'
      # post 'authorize/:provider', to: 'auth#authorize'
      match 'auth/twitter', to: 'auth#twitter', via: [:get,:post]
      post '/twitter_step_2', to: 'auth#twitter_step_2'
      post 'auth/create_new_user', to: 'auth#create_new_user'
      post  'tweets/get_user_info', to: 'tweets#user_info'
    end
  end
end
