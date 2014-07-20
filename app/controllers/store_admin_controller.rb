# encoding: UTF-8
class StoreAdminController < ApplicationController
  before_action :set_supplier_account, :check_if_user_has_related_supplier_account, except: [:stores]
  before_action :set_date_range, only: [:purchase_details, :report_sales_charts, :report_daily, :report_sales_and_costs]
  
  def point_of_sale
    @shopping_cart = params[:shopping_cart_id].blank? ? ShoppingCart.create(user_id: current_user.id) : ShoppingCart.find(params[:shopping_cart_id])
    @purchase_aux = Purchase.new
    @purchase_aux.payments.build
    @purchase_aux.gift_cards.build
  end

  def menu
    
  end

  def inventory_reconciliation
    @inventory_reconciliation = InventoryReconciliation.where(:status => 'active').last
    if @inventory_reconciliation.blank?
      @inventory_reconciliation = InventoryReconciliation.create(status: 'active', user_id: current_user.id, supplier_account_id: @supplier_account.id)
    end
    
    if cookies[:warehouse_id].blank?
      cookies[:warehouse_id] = current_user.supplier_accounts.first.warehouses.first.id
    end
    @warehouse = Warehouse.find(cookies[:warehouse_id])
    @products_to_reconcile = 0
    product_stock_size_to_reconcile_ids = Array.new
    @inventory_reconciliation.product_reconciliations.each do |pr|
      wpss = WarehouseProductSizeStock.where("product_stock_size_id = ? and warehouse_id = ?", pr.product_stock_size.barcode, @warehouse.id).first
      unless wpss.blank?
        if wpss.stock != pr.count
          product_stock_size_to_reconcile_ids << pr.id
          @products_to_reconcile = @products_to_reconcile + 1
        end
      end
    end
    @not_found_warehouse_product_size_stock = WarehouseProductSizeStock.where('warehouse_id = ? and product_stock_size_id not in (?) and stock > 0',  @warehouse.id, @inventory_reconciliation.product_reconciliations.map(&:product_stock_size_id)).paginate(:page => params[:page], :per_page => 15)
    @products_not_reconciled = @not_found_warehouse_product_size_stock.size 
      @show_not_added = false
    if params[:view] == 'added-not-reconciled'
      @table_title = 'Productos encontrados que requieren ajuste de stock'
      @product_reconciliations = @inventory_reconciliation.product_reconciliations.where('product_reconciliations.id in (?)', product_stock_size_to_reconcile_ids).paginate(:page => params[:page], :per_page => 15)
    elsif params[:view] == 'not-added'
      @show_not_added = true
      @table_title = 'Productos no encontrados durante la reconciliación'
    else
      @table_title = 'Todos los productos encontrados'
      @product_reconciliations = @inventory_reconciliation.product_reconciliations.paginate(:page => params[:page], :per_page => 15)
    end
  end
  
  def product_reception
    @q = params[:q]
    unless @q.blank?
      @product_stock_sizes = @warehouse.product_stock_sizes.joins(:product).where('products.name like "%'+@q+'%" or products.internal_code like "%'+@q+'%" or products.description like "%'+@q+'%" or product_stock_sizes.size_id like "%'+@q+'%" or product_stock_sizes.color like "%'+@q+'%" or product_stock_sizes.barcode like "%'+@q+'%"').paginate(:page => params[:page], :per_page => 15).order 'created_at DESC'
    end
    unless params[:product_stock_size_id].blank? or params[:add_stock].blank?
      begin
        psz = ProductStockSize.find params[:product_stock_size_id]
        wpss = WarehouseProductSizeStock.where("product_stock_size_id = ? and warehouse_id = ?", psz.id, @warehouse.id).first  
        wpss.update_attribute :stock, wpss.stock + params[:add_stock].to_i
        psz.update_attribute :stock, psz.stock + params[:add_stock].to_i
        flash[:notice] = 'Stock actualizado del producto '+psz.string_for_select+'<br />Pasó de '+(wpss.stock - params[:add_stock].to_i).to_s+' a '+wpss.stock.to_s
      rescue Exception => exc
        flash[:alert] = 'Error al actualizar el stock. Producto no encontrato o Stock ingresado en formato inválido'
      end
    end
  end
  
  def add_product_to_inventory_reconciliation_from_barcode
    begin
      @inventory_reconciliation = InventoryReconciliation.find params[:inventory_reconciliation_id] if !params[:inventory_reconciliation_id].nil? 
      barcode = params[:barcode] 
      product_stock_size = ProductStockSize.find_by_barcode barcode
      unless product_stock_size.blank?
        pr = ProductReconciliation.where('inventory_reconciliation_id = ? and product_stock_size_id = ?', @inventory_reconciliation.id, product_stock_size.id).first
        if pr.blank?
          ProductReconciliation.create(inventory_reconciliation_id: @inventory_reconciliation.id, product_stock_size_id: product_stock_size.id, count: 1)
        else
          pr.update_attribute :count, pr.count + 1 
        end
        redirect_to inventory_reconciliation_path(id: @supplier_account.id), notice: 'Producto Registrado'
      end
    rescue Exception => exc
      redirect_to inventory_reconciliation_path(id: @supplier_account.id), alert: 'Error: Producto no existe'
    end
  end

  def remove_product_from_inventory_reconciliation
    @inventory_reconciliation = InventoryReconciliation.find params[:inventory_reconciliation_id] if !params[:inventory_reconciliation_id].nil? 
    pr = ProductReconciliation.find params[:product_reconciliation_id]
    pr.update_attribute :count, pr.count - 1
    redirect_to inventory_reconciliation_path(id: @supplier_account.id)
  end
  
  def adjust_product_stock
    if !params[:product_reconciliation_id].blank?
      product_reconciliation = ProductReconciliation.find params[:product_reconciliation_id]
      unless product_reconciliation.blank?
        @warehouse = Warehouse.find(cookies[:warehouse_id])
        wpss = WarehouseProductSizeStock.where("product_stock_size_id = ? and warehouse_id = ?", product_reconciliation.product_stock_size.id, @warehouse.id).first
        change_in_stock = product_reconciliation.count - wpss.stock
        product_reconciliation.product_stock_size.update_attribute :stock, product_reconciliation.product_stock_size.stock + change_in_stock
        wpss.update_attribute :stock, product_reconciliation.count

        redirect_to inventory_reconciliation_path(id: @supplier_account.id), notice: 'Yahuuu... ¡Stock Actualizado!'
      else
        redirect_to inventory_reconciliation_path(id: @supplier_account.id), alert: 'ERROR: Stock encontrado pero no actualizado - Consulta con el Administrador'
      end      
    elsif !params[:warehouse_product_size_stock_id].blank?
      wpss = WarehouseProductSizeStock.find params[:warehouse_product_size_stock_id]
      wpss.product_stock_size.update_attribute :stock, wpss.product_stock_size.stock - wpss.stock
      wpss.update_attribute :stock, 0
      redirect_to inventory_reconciliation_path(id: @supplier_account.id, view: 'not-added'), notice: 'Yahuuu... ¡Stock Actualizado de '+wpss.product_stock_size.product.name+'!'
    else
      redirect_to inventory_reconciliation_path(id: @supplier_account.id), alert: 'ERROR DESCONOCIDO: Consulta con el Administrador'
    end
  end
  
  def end_inventory_reconciliation
    inventory_reconciliation = InventoryReconciliation.find params[:inventory_reconciliation_id]
    inventory_reconciliation.update_attribute :status, 'terminated'
    redirect_to inventory_reconciliation_path(id: @supplier_account.id), notice: 'Consolidación de Inventario Finalizada'
  end
  
  def reports
    add_breadcrumb "Reportes", store_admin_reports_path(id: @supplier_account.id)
  end
  
  def report_daily
    add_breadcrumb "Reportes", store_admin_reports_path(id: @supplier_account.id)
    add_breadcrumb "Reporte de Venta Diario", store_admin_report_daily_path(id: @supplier_account.id)
  end
  
  def report_sales_charts
    add_breadcrumb "Reportes", store_admin_reports_path(id: @supplier_account.id)
    add_breadcrumb "Gráficos de Venta", store_admin_report_sales_charts_path(id: @supplier_account.id)
    @purchases = @supplier_account.purchases.where('purchases.created_at >= ? and purchases.created_at <= ?', @from, @to).order 'purchases.created_at DESC'
  end
  
  def report_inventory
    add_breadcrumb "Reportes", store_admin_reports_path(id: @supplier_account.id)
    add_breadcrumb "Inventario", store_admin_report_inventory_path(id: @supplier_account.id)
    
    @products = @supplier_account.products
    @product_categories = @supplier_account.product_categories
    @sizes = @supplier_account.sizes
  end
  
  def report_accounts_payable
    add_breadcrumb "Reportes", store_admin_reports_path(id: @supplier_account.id)
    add_breadcrumb "Gastos por Pagar", store_admin_report_accounts_payable_path(id: @supplier_account.id)
    
    @expenses = @supplier_account.expenses.where('paid is not true')
    
    respond_to do |format|
      format.html
      format.xls
    end
    
  end
  
  def report_sales_and_costs
    add_breadcrumb "Reportes", store_admin_reports_path(id: @supplier_account.id)
    add_breadcrumb "Ingresos y Gastos", store_admin_report_sales_and_costs_path(id: @supplier_account.id)
    
    @hours_off_set = (DateTime.now.in_time_zone(@time_zone).utc_offset/60/60).abs
    
    if params[:interval] == 'day'
      @to = @to.end_of_day
      @from = @from.beginning_of_day
      @interval = 1.day
    elsif params[:interval] == 'week'
      @to = @to.in_time_zone(@time_zone).end_of_week
      @from = @from.in_time_zone(@time_zone).beginning_of_week
      @interval = 1.week
    else
      params[:interval] = 'month'
      @to = @to.in_time_zone(@time_zone).end_of_month
      @from = @from.in_time_zone(@time_zone).beginning_of_month
      @interval = 1.month
    end
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
      product_stock_size = ProductStockSize.where('barcode = ? or internal_code like "%'+barcode+'%"', barcode).first
      unless product_stock_size.blank?
        if product_stock_size.stock == 0
          redirect_to point_of_sale_path(id: @supplier_account.id, shopping_cart_id: @shopping_cart.id), alert: 'Error: Producto Agotado en el Sistema'
        else
          sci = ShoppingCartItem.where('product_stock_size_id = ? and shopping_cart_id = ?', product_stock_size.id, @shopping_cart.id).first
          unless sci.blank? 
            sci.update_attribute :quantity, sci.quantity + 1
          else
            @shopping_cart.shopping_cart_items << ShoppingCartItem.create(shopping_cart_id: @shopping_cart.id, product_stock_size_id: product_stock_size.id, quantity: 1)
          end
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
    @error_message = 'Error desconocido al generar la compra'
    begin
      @error_message = 'No se puede generar la compra porque la bodega no ha sido seleccionada'
      @warehouse = Warehouse.find(cookies[:warehouse_id])
      @error_message = 'No se puede generar la compra porque el carrito de compras no se ha encontrado'
      @shopping_cart = ShoppingCart.find params[:shopping_cart_id]
      @error_message = 'Error creando al comprador'
      customer = create_customer
      @error_message = 'Error generando la compra'
      purchase = create_purchase(customer)
      #Disable Cart
      @shopping_cart.update_attribute :status, 'comprado'
      unless purchase.customer.blank? or purchase.customer.email.blank?
        @error_message = 'Error al enviar el correo de compra.- Compra Generada OK.'
        Notifications.purchase_details(purchase).deliver
      end
      redirect_to supplier_account_purchase_path(supplier_account_id: @supplier_account.id, id: purchase.id), notice: 'Venta generada exitosamente'
    rescue Exception => exc    
      redirect_to point_of_sale_path(id: @supplier_account.id, shopping_cart_id: @shopping_cart.id), alert: @error_message
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
        @from = DateTime.now.in_time_zone(@time_zone).beginning_of_week(start_day = :monday)
        @to = DateTime.now.in_time_zone(@time_zone).end_of_week(start_day = :monday)
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
      
      gift_cards = Array.new
      unless params[:purchase][:gift_cards_attributes].blank?
        params[:purchase][:gift_cards_attributes].each do |gift_card_params|
          unless gift_card_params[1][:barcode].blank?
            gift_card = GiftCard.find_by_barcode gift_card_params[1][:barcode]
            unless gift_card.blank? or gift_card.status == 'used'
              gift_card.update_attribute :status, 'used'
              total = total - gift_card.amount
              gift_cards << gift_card
            else 
              @error_message = 'GiftCard no válida.'
              raise "error"
            end
          end
        end
      end
      
      #Reduce Stock
      @shopping_cart.shopping_cart_items.each do |sci|
        @error_message = 'El producto no se encuentra disponible en la bodega '+@warehouse.name
        wpss = WarehouseProductSizeStock.where("product_stock_size_id = ? and warehouse_id = ?", sci.product_stock_size.id, @warehouse.id).first  
        wpss.update_attribute :stock, wpss.stock - sci.quantity
        sci.product_stock_size.update_attribute :stock, sci.product_stock_size.stock - sci.quantity
      end
      @error_message = 'Error al guardar la compra. Consulta con el administrador.'
      if customer.blank?
        purchase = Purchase.create(shopping_cart_id: @shopping_cart.id, invoice_number: params[:invoice_number], warehouse_id: cookies[:warehouse_id],
              supplier_account_id: @supplier_account.id, discount: discount, discount_type: discount_type, user_id: current_user.id)
      else
        purchase = Purchase.create(shopping_cart_id: @shopping_cart.id, invoice_number: params[:invoice_number], warehouse_id: cookies[:warehouse_id],
              supplier_account_id: @supplier_account.id, discount: discount, discount_type: discount_type, customer_id: customer.id, user_id: current_user.id)
      end
      @error_message = 'Error al generar los pagos. Consulta con el administrador.'
      unless params[:purchase][:payments_attributes].blank?
        params[:purchase][:payments_attributes].each do |payment_params|
          unless payment_params[1][:amount].blank? or payment_params[1][:payment_method_id].blank?
            Payment.create(amount: payment_params[1][:amount], payment_method_id: payment_params[1][:payment_method_id], purchase_id: purchase.id)
          else
            @error_message = 'Debes agregar un Monto a pagar y el Medio de Pago.'
            raise "error"
          end
        end
      end
      
      gift_cards.each do |gc|
        gc.update_attribute(:purchase_id, purchase.id) unless gc.blank?
      end
      
      return purchase
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
