Rails.application.routes.draw do
  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end
  post '/graphql', to: 'graphql#execute'
  devise_for :users

  root 'home#welcome'
  resources :genres, only: :index do
    member do
      get 'movies'
    end
  end
  resources :movies, only: %i[index show] do
    member do
      get :send_info
    end
    collection do
      get :export
    end
  end
  resources :comments, only: %i[index create destroy]
end
