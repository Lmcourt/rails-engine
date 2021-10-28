Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#find'
      get 'merchants/most_items', to: 'merchants/most_items#merchant_most_items'
      get 'items/find_all', to: 'items/search#find_all'
      resources :merchants, only: [:index, :show] do
        resources :items, only: :index
      end
      resources :items do
        get '/merchant', to: 'items_merchant#show'
      end
      namespace :revenue do
        get '/merchants', to: 'merchants#merchants_most_revenue'
        get '/merchants/:merchant_id', to: 'merchants#merchant_revenue'
        get '/items', to: 'items#items_most_revenue'
      end
    end
  end
end
