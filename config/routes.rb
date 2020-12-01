Rails.application.routes.draw do
  get 'posts/new'
  get 'posts/create'
  get 'posts/show'
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
  resources :users, only: [:show]
  resources :protectors, only: [:show]
  resources :dogs do
    resources :posts, only: [:new, :create, :show, :destroy]
  end
end
