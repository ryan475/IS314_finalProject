Rails.application.routes.draw do
  devise_for :users
  devise_for :admins
  
  # User profile route
  get 'profile', to: 'users#profile'

  namespace :admin do
    devise_for :admins, controllers: {
      sessions: 'admin/sessions'
    }
  
  # Super Admin dashboard
  namespace :super_admin do
    get 'dashboard', to: 'super_admins#dashboard'
    # Additional super admin routes
  end
    resources :products do
      member do
        delete :remove_image
      end
    end

    resources :orders
    resources :users
  end

  resources :products, only: [:index, :show, :create, :update, :destroy]

  root "admin/products#index"
end
