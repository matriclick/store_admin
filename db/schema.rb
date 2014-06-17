# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140617050316) do

  create_table "currencies", force: true do |t|
    t.string   "symbol"
    t.string   "name"
    t.integer  "supplier_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "rut"
    t.datetime "birthday"
    t.string   "phone_number"
    t.integer  "supplier_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "daily_store_data", force: true do |t|
    t.datetime "date"
    t.integer  "came_in_clients"
    t.integer  "supplier_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "warehouse_id"
    t.text     "comments"
  end

  create_table "expense_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_account_id"
  end

  create_table "expenses", force: true do |t|
    t.decimal  "amount",              precision: 10, scale: 0
    t.integer  "currency_id"
    t.integer  "expense_type_id"
    t.string   "paid_by"
    t.datetime "pay_date"
    t.boolean  "paid"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_account_id"
  end

  create_table "gift_cards", force: true do |t|
    t.integer  "customer_id"
    t.string   "barcode"
    t.decimal  "amount",              precision: 10, scale: 0
    t.datetime "valid_until"
    t.string   "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_account_id"
  end

  create_table "gift_cards_shopping_cart_items", id: false, force: true do |t|
    t.integer "shopping_cart_item_id"
    t.integer "gift_card_id"
  end

  create_table "inventory_reconciliations", force: true do |t|
    t.integer  "supplier_account_id"
    t.integer  "user_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "payment_methods", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_account_id"
  end

  create_table "payments", force: true do |t|
    t.integer  "purchase_id"
    t.integer  "payment_method_id"
    t.decimal  "amount",            precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "petty_cashes", force: true do |t|
    t.decimal  "close_amount",        precision: 10, scale: 0
    t.integer  "supplier_account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_account_id"
  end

  create_table "product_categories_products", id: false, force: true do |t|
    t.integer "product_id"
    t.integer "product_category_id"
  end

  create_table "product_images", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "product_id"
  end

  create_table "product_reconciliations", force: true do |t|
    t.integer  "inventory_reconciliation_id"
    t.integer  "product_stock_size_id"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_stock_sizes", force: true do |t|
    t.integer  "product_id"
    t.integer  "size_id"
    t.string   "color"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "barcode"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price",               precision: 10, scale: 0
    t.integer  "supplier_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "internal_code"
  end

  create_table "providers", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_account_id"
  end

  create_table "purchases", force: true do |t|
    t.integer  "shopping_cart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_account_id"
    t.integer  "customer_id"
    t.decimal  "discount",              precision: 10, scale: 0
    t.string   "discount_type"
    t.integer  "user_id"
    t.string   "invoice_number"
    t.string   "change_ticket_barcode"
    t.string   "status"
    t.integer  "gift_card_id"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopping_cart_items", force: true do |t|
    t.integer  "shopping_cart_id"
    t.integer  "product_stock_size_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "shopping_carts", force: true do |t|
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "sizes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_account_id"
  end

  create_table "store_admin_privileges", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "store_admin_privileges_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "store_admin_privilege_id"
  end

  create_table "supplier_accounts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.text     "purchase_details_mail_text"
    t.string   "store_web"
  end

  create_table "supplier_accounts_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "supplier_account_id"
  end

  create_table "supply_purchase_product_sizes", force: true do |t|
    t.integer  "product_stock_size_id"
    t.integer  "quantity"
    t.decimal  "unit_cost",             precision: 10, scale: 0
    t.integer  "currency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supply_purchase_id"
  end

  create_table "supply_purchases", force: true do |t|
    t.integer  "provider_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "warehouse_product_size_stocks", force: true do |t|
    t.integer  "product_stock_size_id"
    t.integer  "warehouse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock"
  end

  create_table "warehouses", force: true do |t|
    t.integer  "supplier_account_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default"
  end

end
