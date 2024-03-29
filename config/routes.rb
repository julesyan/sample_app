SampleApp::Application.routes.draw do
  # This will allow us to access the users in a REST-style way (/user/#) 
  # which includes the /user/new
  resources :users do
    #get "users/new"
    member do
      get :following, :followers
    end
  end

  # This will define new routes for the sessions (sign in and out sessions). 
  # This will restrict us to new, create and destroy since we dont want any 
  # other actions
  resources :sessions, only: [:new, :create, :destroy]

  # This will allow us to create and destroy microposts 
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  #This requests the URL 'static_pages/home' which corresponds ot hte home action from StaticPages
  #We use 'get' because we want to use the GET protocol
  #get "static_pages/home"
  #get "static_pages/help"
  #get "static_pages/about"
  #get "static_pages/contact"
  root 'static_pages#home'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  # This one is delete because we are signing out and thus invoking a HTTP 
  # DELETE request
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/help', to: 'static_pages#help', via: 'get'
  match '/about', to: 'static_pages#about', via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
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
