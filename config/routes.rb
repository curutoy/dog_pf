Rails.application.routes.draw do
  devise_for :protectors, controllers: {
    sessions: 'protectors/sessions',
    passwords: 'protectors/passwords',
    registrations: 'protectors/registrations',
  }

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  root 'dogs#index'
  resources :users, only: [:show] do
    resources :pets,      only: [:new, :create, :edit, :update, :destroy]
    resources :favorites, only: [:index]
  end

  resources :protectors, only: [:show]
  resources :dogs do
    resources :posts, only: [:new, :create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]
  resources :favorites,     only: [:create, :destroy]
  resources :messages,      only: [:create]
  resources :rooms,         only: [:create, :index, :show]
  resources :events
  resources :notifications, only: [:index]
end
