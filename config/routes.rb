Rails.application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'users/sessions'}

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :studio_connections do
    get 'repositories'
    get 'dashboard'
    get 'dashboard/query/:query_id' => "studio_connections#dash_query", :as => "dash_query"
    get 'repositories/:repo_name' => "studio_connections#show_repo", :as => "show_repo"
    get 'repositories/:repo_name/input:path' =>"studio_connections#browse_repo",
      :as => "browse_repo", :constraints => { :path => /\/.+(?=\.html\z|\.template\z)/ }
    get 'repositories/:repo_name/history/:guid' => "studio_connections#history", :as => "object_history"
    get 'repositories/:repo_name/object/:guid' => "studio_connections#object_dump", :as => "object_browse"
    get 'repositories/:repo_name/stats' => "studio_connections#repo_stats", :as => "repo_stats"
    get 'repositories/:repo_name/stats/:object' => "studio_connections#repo_object_stats", :as => "repo_object_stats"
    get 'repositories/:repo_name/conformity' => "studio_connections#conformity", :as => "conformity"
    get 'repositories/:repo_name/users' => "studio_connections#repo_users", :as => "repo_users"
    get 'repositories/:repo_name/users/:id' => "studio_connections#repo_user", :as => "repo_user"
    get 'users' => "studio_connections#users", :as => "users"
    get 'users/:username' => "studio_connections#user", :as => "user"
  end

  resources :settings, :only => [:index] do
    collection do
      get 'connections'
      resources :statistics, :only => [:index]  do
        collection do
          get 'edit_categories'
          patch 'update_categories'
          get 'edit_headers'
          patch 'update_headers'
        end
      end
      get 'indexes'
    end
  end

  resources :statistics, :only => [] do
    collection do
      get 'new_category'
      get 'new_header'
    end
  end

  resources :studio_indices do
    get 'env_dump'
  end

  resources :babylon_test, :only => [:index] do
  end

  #get 'settings' => "welcome#settings"

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
