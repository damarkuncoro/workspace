Rails.application.routes.draw do
  devise_for :accounts, 
    controllers: { 
      confirmations: 'accounts/confirmations',
      password: 'accounts/password',
      registrations: 'accounts/registrations',
      sessions: 'accounts/sessions',
      unlocks: 'accounts/unlocks',
    }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  scope module: 'protected', as: 'protected' do
    get :dashboard, to: 'dashboard#index', as: :dashboard


    resources :people

     

    resources :customers do
      resources :issues, controller: 'issues/customers' do
        resources :comments, controller: 'issues/comments', only: [:create]
      end
    end

    resources :employees do
      resources :issues, controller: 'issues/employees' do
        resources :comments, controller: 'issues/comments', only: [:create]
      end
    end

    get 'profile', to: 'profile#show', as: :profile_show
    get 'profile/edit', to: 'profile#edit', as: :profile_edit
    patch 'profile', to: 'profile#update', as: :profile_update
    get 'roles', to: 'roles#show', as: :roles_show
    get 'roles/edit', to: 'roles#edit', as: :roles_edit
    patch 'roles', to: 'roles#update', as: :roles_update

    scope module: :issues do
      get '/issues', to: 'issues#index', as: :issues
      get '/issues/customers', to: 'issues#customers', as: :issues_customers
      get '/issues/employees', to: 'issues#employees', as: :issues_employees
    end

  end


    

  namespace :protected do
    
    resources :accounts do
      resources :customers, only: [:new]
      resources :employees, only: [:new]
    end
  end



  get "demo1", to: "metronic/demo1#index"
  root to: 'frontend/home#index'

end
