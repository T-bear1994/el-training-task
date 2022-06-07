Rails.application.routes.draw do
  resources :labels
  root 'sessions#new'
  resources :tasks
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  namespace :admin do
    resources :users
  end
  resources :labels
end
