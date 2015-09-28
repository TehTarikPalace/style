Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :studio_connections do
    get 'repositories'
    get 'repositories/:repo_name' => "studio_connections#show_repo", :as => "show_repo"
    get 'repositories/:repo_name:path' =>"studio_connections#browse_repo",
      :as => "browse_repo", :constraints => { :path => /\/.+(?=\.html\z|\.template\z)/ }
    get 'history/:repo_name/:guid' => "studio_connections#history", :as => "object_history"
    get 'object/:repo_name/:guid' => "studio_connections#object_dump", :as => "object_browse"
    get 'stats/:repo_name' => "studio_connections#repo_stats", :as => "repo_stats"
    get 'stats/:repo_name/:object' => "studio_connections#repo_object_stats", :as => "repo_object_stats"
  end

  resources :settings, :only => [:index] do
    collection do
      get 'connections'
      #get 'statistics'
      resources :statistics, :only => [:index]  do
        collection do
          get 'edit_categories'
          patch 'update_categories'
          get 'edit_headers'
          patch 'update_headers'
        end

      end
    end
  end

  resources :statistics, :only => [] do
    collection do
      get 'new_category'
      get 'new_header'
    end
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
