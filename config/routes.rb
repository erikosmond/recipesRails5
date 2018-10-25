# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users
  root to: 'pages#home'
  namespace :api, defaults: { format: :json } do
    resources :recipes, only: %i[show index]

    resources :tags do
      resources :recipes, only: %i[index]
    end
  end
  match '/*page' => 'pages#home', via: :get
end
