Europodatki::Application.routes.draw do
  resources :agents

  resources :bills

  resources :clearings do
    member do
      get 'history'
    end
    resource :bill, only: [:new]
    resources :messages, only: [:new, :index]
  end

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
    resources :clearings, only: [:new, :index]
  end

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => 'home#index'

  devise_for :users

  resources :users, :only => [:show, :index]

  match 'home/administration' => 'home#administration'
  match 'home/reports' => 'home#reports'
end
