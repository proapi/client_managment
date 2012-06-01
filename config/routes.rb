Europodatki::Application.routes.draw do
  resources :bills

  resources :clearings

  resources :companies

  resources :documents

  resources :countries do
    resources :documents, only: [:new, :index]
  end

  resources :messages

  resources :clients do
    member do
      get 'history'
    end
    resources :messages, only: [:new, :index]
  end

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => 'home#index'

  devise_for :users

  resources :users, :only => [:show, :index]

  match 'home/administration' => 'home#administration'
end
