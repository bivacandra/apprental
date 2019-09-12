Rails.application.routes.draw do
  resources :payments do
    collection do
      post :receive_webhook
    end
  end  
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :cars
  resources :orders
  post 'orders/new'
end
