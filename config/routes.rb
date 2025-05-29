Rails.application.routes.draw do
  resources :finances, only: [ :index ] do
    collection do
      post :send_money
      post :create_finance
      post :top_up
    end
  end
  resources :users, only: %i[index] do
    collection do
      get :my_communities
    end
  end
  resources :communities
  get "home/index"
  root "home#index"
  get "registrations/new"
  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
