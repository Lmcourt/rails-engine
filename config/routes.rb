Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#find'
      get 'items/find_all', to: 'items/search#find_all'
      resources :merchants, only: [:index, :show] do
        resources :items, only: :index
      end
      resources :items do
        get '/merchant', to: 'items_merchant#show'
      end
    end
  end
end
