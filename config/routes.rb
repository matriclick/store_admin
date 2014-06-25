StoreAdmin::Application.routes.draw do
  get "store_admin/stores", as: :user_root    
  get "store_admin/:id/point_of_sale" => 'store_admin#point_of_sale', as: 'point_of_sale'
  get "store_admin/:id/products" => 'store_admin#products', as: 'store_admin_products'
  get "store_admin/:id/users" => 'store_admin#users', as: 'store_admin_users'

  get "store_admin/:id/reports" => 'store_admin#reports', as: 'store_admin_reports'
    get "store_admin/:id/report_daily" => 'store_admin#report_daily', as: 'store_admin_report_daily'
  get "store_admin/:id/report_sales_charts" => 'store_admin#report_sales_charts', as: 'store_admin_report_sales_charts'
  get "store_admin/:id/report_inventory" => 'store_admin#report_inventory', as: 'store_admin_report_inventory'
  get "store_admin/:id/report_accounts_payable" => 'store_admin#report_accounts_payable', as: 'store_admin_report_accounts_payable'
  get "store_admin/:id/menu" => 'store_admin#menu', as: 'store_admin_menu'
  get "store_admin/:id/inventory_reconciliation" => 'store_admin#inventory_reconciliation', as: 'inventory_reconciliation'
  
  
  post 'store_admin/:id/add_product_to_cart_from_barcode/' => 'store_admin#add_product_to_cart_from_barcode', as: 'store_admin_add_product_to_cart_from_barcode'
  put 'store_admin/:id/generate_purchase/:shopping_cart_id' => 'store_admin#generate_purchase', as: 'store_admin_generate_purchase'
  put 'store_admin/:id/remove_product_from_cart_path/:shopping_cart_id' => 'store_admin#remove_product_from_cart', as: 'store_admin_remove_product_from_cart'
  post 'store_admin/:id/adjust_product_stock' => 'store_admin#adjust_product_stock', as: 'store_admin_adjust_product_stock'
  post 'store_admin/:id/end_inventory_reconciliation/:inventory_reconciliation_id' => 'store_admin#end_inventory_reconciliation', as: 'store_admin_end_inventory_reconciliation'
  
  
  post 'store_admin/:id/add_product_to_inventory_reconciliation_from_barcode/' => 'store_admin#add_product_to_inventory_reconciliation_from_barcode', as: 'store_admin_add_product_to_inventory_reconciliation_from_barcode'
  put 'store_admin/:id/remove_product_from_inventory_reconciliation/:inventory_reconciliation_id' => 'store_admin#remove_product_from_inventory_reconciliation', as: 'store_admin_remove_product_from_inventory_reconciliation'
    
  get "supplier_accounts/:id/edit_user_privileges/:user_id" => 'supplier_accounts#edit_user_privileges', as: 'supplier_account_edit_user_privileges'
  put "supplier_accounts/:id/remove_user/:user_id" => 'supplier_accounts#remove_user', as: 'supplier_account_remove_user'
  put "supplier_accounts/:id/add_user" => 'supplier_accounts#add_user', as: 'supplier_account_add_user'
  post "supplier_accounts/:id/update_user/:user_id" => 'supplier_accounts#update_user', as: 'supplier_account_update_user'
  get 'supplier_accounts/autocomplete_user_email' => 'supplier_accounts#autocomplete_user_email'
  
  post 'set_time_zone' => 'application#set_time_zone', as: 'set_time_zone'
  post 'check_if_costumer_exists' => 'application#check_if_costumer_exists', as: 'check_if_costumer_exists'
  post 'search_products_ajax' => 'application#search_products_ajax', as: 'search_products_ajax'
  post 'get_gift_card_value' => 'application#get_gift_card_value', as: 'get_gift_card_value'
  resources :supplier_accounts do
    put 'product/:id/update_barcode/:product_stock_size_id' => 'products#update_barcode', as: 'update_barcode'
    get 'product/:id/distribute_stock' => 'products#distribute_stock', as: 'product_distribute_stock'
    post 'product/:id/update_distribution' => 'products#update_distribution', as: 'product_update_distribution'
    get :autocomplete_user_email, :on => :collection
    resources :products do
      collection { post :import }
      collection { get :barcodes }
    end
    resources :payment_methods
    resources :petty_cashes
    resources :currencies
    resources :expenses
    resources :expense_types
    resources :gift_cards
    resources :sizes
    resources :product_categories
    resources :customers
    resources :daily_store_data
    resources :warehouses
    post 'purchase/:id/return_product' => 'purchases#return_product', as: 'purchase_return_product'
    get 'purchase/:id/change_ticket' => 'purchases#change_ticket', as: 'purchase_change_ticket'
    resources :purchases
    resources :providers do
        resources :supply_purchases do
          collection { post :search_product }
        end
    end
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
