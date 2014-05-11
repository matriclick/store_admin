StoreAdmin::Application.routes.draw do

  get "store_admin/stores", as: :user_root
    
  get "store_admin/:id/point_of_sale" => 'store_admin#point_of_sale', as: 'point_of_sale'
  get "store_admin/:id/products" => 'store_admin#products', as: 'store_admin_products'
  get "store_admin/:id/users" => 'store_admin#users', as: 'store_admin_users'
  get "store_admin/:id/reports" => 'store_admin#reports', as: 'store_admin_reports'
  get "store_admin/:id/purchase_details" => 'store_admin#purchase_details', as: 'store_admin_purchase_details'
  get "store_admin/:id/sales_summary" => 'store_admin#sales_summary', as: 'store_admin_sales_summary'
  get "store_admin/:id/inventory" => 'store_admin#inventory', as: 'store_admin_inventory'

  post 'store_admin/:id/add_product_to_cart_from_barcode/' => 'store_admin#add_product_to_cart_from_barcode', as: 'store_admin_add_product_to_cart_from_barcode'

  put 'store_admin/:id/generate_purchase/:shopping_cart_id' => 'store_admin#generate_purchase', as: 'store_admin_generate_purchase'
  put 'store_admin/:id/remove_product_from_cart_path/:shopping_cart_id/:shopping_cart_id' => 'store_admin#remove_product_from_cart', as: 'store_admin_remove_product_from_cart'
    
  get "supplier_accounts/:id/edit_user_privileges/:user_id" => 'supplier_accounts#edit_user_privileges', as: 'supplier_account_edit_user_privileges'
  put "supplier_accounts/:id/remove_user/:user_id" => 'supplier_accounts#remove_user', as: 'supplier_account_remove_user'
  put "supplier_accounts/:id/add_user" => 'supplier_accounts#add_user', as: 'supplier_account_add_user'
  post "supplier_accounts/:id/update_user/:user_id" => 'supplier_accounts#update_user', as: 'supplier_account_update_user'
  get 'supplier_accounts/autocomplete_user_email' => 'supplier_accounts#autocomplete_user_email'
  
  post 'set_time_zone' => 'application#set_time_zone', as: 'set_time_zone_path'

  resources :supplier_accounts do
    put 'product/:id/update_barcode/:product_stock_size_id' => 'products#update_barcode', as: 'update_barcode'
    resources :products
    resources :sizes
    resources :product_categories
  end

  devise_for :users
  
  # You can have the root of your site routed with "root"
  devise_scope :user do
    root to: "devise/sessions#new"
  end
  
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
