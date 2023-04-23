Rails.application.routes.draw do
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  root "dashboard#index"
  devise_for :users

  get 'dashboard/index'

  resources :enterprises, only: [:index, :show, :new, :create, :edit, :update] do
    member do
      patch :activate
      patch :disable
    end
  end

  namespace :admin do
    resources :users, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        patch :disable
        patch :activate
        patch :update_current_enterprise
      end
    end
  end

  namespace :user do
    resources :roles, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :clients, only: [:index, :new, :create]
end
