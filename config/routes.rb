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
  root to: 'cars#index'

  match "/payments/receive_webhook" => "payments#receive_webhook", via: [:post]

end
