Rails.application.routes.draw do
  root 'dogs#index'

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

  resources :users, only: [:show]

  resources :protectors, only: [:show]
end
