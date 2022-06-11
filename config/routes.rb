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
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
