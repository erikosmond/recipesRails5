# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users
  root to: 'pages#home'
  namespace :api, defaults: { format: :json } do
    resources :recipes, only: %i[index show]

    resources :tags, only: %i[index show] do
      resources :recipes, only: %i[index]
    end
  end
  match '/*page' => 'pages#home', via: :get
end
