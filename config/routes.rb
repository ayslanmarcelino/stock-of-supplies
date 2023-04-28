Rails.application.routes.draw do
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  root "dashboard#index"
  devise_for :users

  get 'dashboard/index'

  namespace :admin do
    resources :users, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        patch :disable
        patch :enable
        patch :update_current_unit
      end
    end
  end

  namespace :user do
    resources :roles, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :supplies, only: [:index, :new, :create]

  resources :batches, only: [:index, :new, :create] do
    member do
      patch :increment_amount
      patch :new_output
    end
  end

  resources :movements, only: :index
end
