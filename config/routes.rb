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
    collection do
      get 'autocomplete_client_lastname'
    end
    resources :clearings, only: [:new, :index]
  end

  devise_for :users
  resources :users, :only => [:show, :index]

  #authenticated :user do
  #  root :to => 'home#index'
  #end

  root :to => 'home#index'

  match 'home/administration' => 'home#administration', :as => 'home_administration'
  match 'home/reports' => 'home#reports', :as => 'home_reports'
end
