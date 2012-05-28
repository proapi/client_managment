Europodatki::Application.routes.draw do
  resources :messages

  resources :clients do
    member do
      get 'history'
    end
    resources :messages
  end

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => 'home#index'

  devise_for :users

  resources :users, :only => [:show, :index]
end
