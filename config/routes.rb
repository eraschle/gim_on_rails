# frozen_string_literal: true

Rails.application.routes.draw do
  resources :unit_of_measures
  resources :categories
  resources :parameters
  # For details on the DSL available within this file
  # see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :revit do
        post 'families', action: :create, controller: :families
      end
    end
  end

  resources :families

  root 'families#index'
end
