Tumitfahrer::Application.routes.draw do

  namespace :api do
    # API v1 Routes
    namespace :v1, :defaults => { :format => 'json' } do
      resource :search
      resources :users do
        match '/rides', to: 'rides#get_user_rides', via: :get
        resources :rides do
          match '/contributions', to: 'contributions#contribute_to_ride', via: :post
          resources :contributions
          resources :requests
        end
        resources :devices
        resources :payments
        resources :friends
        resources :friend_requests
        resources :contributions
        resources :projects
        resources :ratings
        resources :messages
      end
      resources :rides do
        resources :passengers
      end
      resource :sessions
      resources :projects
    end
    # API v2 Routes
    namespace :v2, :defaults => { :format => 'json' } do
      resources :activities
      resource :search
      resources :users do
        resources :devices
        match '/rides', to: 'rides#get_user_rides', via: :get
        resources :rides do
          resources :requests
        end        end
      resources :rides do
        resources :requests
      end
      resource :sessions
    end
  end

  # Web app routes
  resources :users
  resources :rides
  resource :sessions, only: [:new, :create, :destroy]

  # Start page route
  root "static_pages#home"
  # Static pages routes
  match "/signup", to: "users#new", via: 'get'
  match "/signin", to: "sessions#new", via: 'get'
  match "/signout", to: "sessions#destroy", via: 'delete'
  match "/help", to: "static_pages#help", via: 'get'
  match "/contact", to: "static_pages#contact", via: 'get'
  match "/about", to: "static_pages#about", via: 'get'
  match "/discover", to: "static_pages#discover", via: 'get'


  # HOW TO:

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
