Rails.application.routes.draw do
  get "pages/home"
  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }

  devise_scope :user do
    get '/users/sign_up/agent', to: 'registrations#new_agent', as: :new_agent_registration
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'pages#home'

  resources :properties, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    collection do
      get 'mes-annonces', to: 'properties#my_properties', as: :my
    end
  end
  resources :agents, only: [:index, :show]
  get 'devenir-agent', to: 'subscriptions#index', as: :subscriptions
  post 'devenir-agent/select-plan', to: 'subscriptions#select_plan', as: :select_plan_subscriptions

  # Namespace admin
  namespace :admin do
    root to: 'dashboard#index'
    get 'dashboard', to: 'dashboard#index'
    
    resources :agents do
      member do
        patch :block
        patch :unblock
      end
    end
  end
end
