Rails.application.routes.draw do
  get 'properties', to: 'properties#index'
  get 'properties/:property_id/collections', to: 'collections#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'application#index'
end
