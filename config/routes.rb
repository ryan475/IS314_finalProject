Rails.application.routes.draw do
  # Devise routes for regular users
  devise_for :users
  
  # User profile route for regular users
  get 'profile', to: 'users#profile'

  # Devise routes for admins inside the admin namespace
  namespace :admin do
    devise_for :admins, controllers: {
      sessions: 'admin/sessions'
    }
  # Define the admin dashboard route
  get 'dashboard', to: 'products#index', as: :dashboard
  
    # Admin resources
    resources :products do
      member do
        delete :remove_image
      end
    end

    resources :orders
    resources :users
  end

  # Super Admin dashboard and additional routes
  namespace :super_admin do
    get 'dashboard', to: 'super_admins#dashboard'
    # Add more super admin-specific routes here
  end

  # Public product routes (accessible to everyone)
  resources :products, only: [:index, :show, :create, :update, :destroy]

  # Set root to the public products index, or change to the desired controller/action
  root "products#index"
end