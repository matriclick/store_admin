class StoreAdminController < ApplicationController
  before_action :set_supplier_account, :check_if_user_has_related_supplier_account, except: [:stores]
  before_action :set_date_range, only: [:purchase_details, :sales_summary]
  
  def point_of_sale
    @shopping_cart = params[:shopping_cart_id].blank? ? ShoppingCart.create(user_id: current_user.id) : ShoppingCart.find(params[:shopping_cart_id])
    if cookies[:warehouse_id].blank?
      cookies[:warehouse_id] = current_user.supplier_accounts.first.warehouses.first.id
    end
    @warehouse = Warehouse.find(cookies[:warehouse_id])
  end

  def products
  end

  def reports
  end
  
  def users
  end

  def reports
  end
  
  def purchase_details
    @q = params[:q]
    @purchases = @supplier_account.get_purchases(@from, @to, @q)
  end
  
  def sales_summary
    @purchases = @supplier_account.purchases.where('purchases.created_at >= ? and purchases.created_at <= ?', @from, @to).order 'purchases.created_at DESC'
  end
  
  def inventory
    @products = @supplier_account.products
    @product_categories = @supplier_account.product_categories
  end
  
  def stores
    if current_user.supplier_accounts.size == 1
      unless current_user.supplier_accounts.first.warehouses == 0
        if cookies[:warehouse_id].blank?
          cookies[:warehouse_id] = current_user.supplier_accounts.first.warehouses.first.id
        end
        redirect_to point_of_sale_path(id: current_user.supplier_accounts.first.id)
      else
        redirect_to supplier_account_warehouses_path(supplier_account_id: current_user.supplier_accounts.first.id)
      end
    end
  end
  
  def add_product_to_cart_from_barcode
    begin
      @shopping_cart = ShoppingCart.find params[:shopping_cart_id] if !params[:shopping_cart_id].nil? 
      barcode = params[:barcode] 
      product_stock_size = ProductStockSize.find_by_barcode barcode
      unless product_stock_size.blank?
        if product_stock_size.stock == 0
          redirect_to point_of_sale_path(id: @supplier_account.id, shopping_cart_id: @shopping_cart.id), alert: 'Error: Producto Agotado en el Sistema'
        else
          @shopping_cart.shopping_cart_items << ShoppingCartItem.create(shopping_cart_id: @shopping_cart.id, product_stock_size_id: product_stock_size.id, quantity: 1)
          redirect_to point_of_sale_path(id: @supplier_account.id, shopping_cart_id: @shopping_cart.id), notice: 'Producto Agregado'
        end
      else
        redirect_to point_of_sale_path(id: @supplier_account.id, shopping_cart_id: @shopping_cart.id), alert: 'Error: Producto no existe'
      end
    rescue Exception => exc
      redirect_to point_of_sale_path(id: @supplier_account.id, shopping_cart_id: @shopping_cart.id), alert: 'Error: Producto no existe'
    end
  end
  
  def generate_purchase
    begin
      @warehouse = Warehouse.find(cookies[:warehouse_id])
      @shopping_cart = ShoppingCart.find params[:shopping_cart_id]
      #Disable Cart
      @shopping_cart.update_attribute :status, 'comprado'
      #Reduce Stock
      @shopping_cart.shopping_cart_items.each do |sci|
        sci.product_stock_size.update_attribute :stock, sci.product_stock_size.stock - 1
        wpss = WarehouseProductSizeStock.where("product_stock_size_id = ? and warehouse_id = ?", sci.id, @warehouse.id).first
        wpss.stock.update_attribute :stock, wpss.stock - 1
      end
      
      customer = create_customer
      purchase = create_purchase(customer)
      
      unless purchase.customer.blank? or purchase.customer.email.blank?
        Notifications.purchase_details(purchase).deliver
      end
      redirect_to point_of_sale_path(id: @supplier_account.id), notice: 'Venta generada exitosamente'
    rescue Exception => exc    
      redirect_to point_of_sale_path(id: @supplier_account.id, shopping_cart_id: @shopping_cart.id), notice: 'Error desconocido al generar la compra'
    end
  end
  
  def remove_product_from_cart
    shopping_cart = ShoppingCart.find params[:shopping_cart_id]
    shopping_cart_item = ShoppingCartItem.find params[:shopping_cart_item_id]
    shopping_cart.shopping_cart_items.delete shopping_cart_item
    redirect_to point_of_sale_path(id: @supplier_account.id, shopping_cart_id: shopping_cart.id), notice: 'Producto eliminado'
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:id])
    end
    
    def set_date_range
      if params[:from].nil? or params[:to].nil?
        @from = DateTime.now.in_time_zone(@time_zone).beginning_of_day
        @to = DateTime.now.in_time_zone(@time_zone).end_of_day
      else
        @from = Time.parse(params[:from]).in_time_zone(@time_zone).beginning_of_day
        @to = Time.parse(params[:to]).in_time_zone(@time_zone).end_of_day
      end
    end
    
    def create_purchase(customer)
      if !params[:percentage_discount].blank?
        discount_type = 'percentage'
        discount = params[:percentage_discount]
        total = @shopping_cart.price * (1-discount.to_f/100)
      elsif !params[:absolute_discount].blank?
        discount_type = 'absolute'
        discount = params[:absolute_discount]
        total = @shopping_cart.price - discount.to_i
      else
        discount_type = 'none'
        discount = 0
        total = @shopping_cart.price
      end
      
      if customer.blank?
        return Purchase.create(payment_method_id: params[:medio_pago], shopping_cart_id: @shopping_cart.id, invoice_number: params[:invoice_number], 
              supplier_account_id: @supplier_account.id, paid_amount: total, discount: discount, discount_type: discount_type, user_id: current_user.id)
      else
        return Purchase.create(payment_method_id: params[:medio_pago], shopping_cart_id: @shopping_cart.id, invoice_number: params[:invoice_number], 
              supplier_account_id: @supplier_account.id, paid_amount: total, discount: discount, discount_type: discount_type, customer_id: customer.id, user_id: current_user.id)
      end
    end
    
    def create_customer
      if !params[:customer][:rut].blank? or !params[:customer][:email].blank?
        if Customer.exists?(rut: params[:customer][:rut])
          customer = Customer.find_by_rut(params[:customer][:rut])
        elsif Customer.exists?(email: params[:customer][:email])
          customer = Customer.find_by_rut(params[:customer][:email])
        else
          customer = Customer.new
        end
        customer.update_attributes(supplier_account_id: params[:customer][:supplier_account_id],
                name: params[:customer][:name], birthday: params[:customer][:birthday], rut: params[:customer][:rut], 
                email: params[:customer][:email], phone_number: params[:customer][:phone_number])
        return customer
      end
      
    end

end
