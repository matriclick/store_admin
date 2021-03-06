# encoding: UTF-8
class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :add_time_zone_variable, :set_warehouse, except: [:set_time_zone]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def set_warehouse
    unless current_user.blank?
      if cookies[:warehouse_id].blank?
        cookies[:warehouse_id] = current_user.supplier_accounts.first.warehouses.first.id
      end
      @warehouse = Warehouse.find(cookies[:warehouse_id])
    end
  end
  
  def authenticate_admin
    unless current_user.is_admin?
      redirect_to root_path, notice: 'No tienes permisos para acceder a esta sección'
    end
  end
  
  def check_if_user_has_related_supplier_account
    if !current_user.is_admin?
      if !current_user.supplier_accounts.include?(@supplier_account)
        redirect_to root_path, notice: 'No tienes permisos para acceder a esta sección'
      end
    end
  end
  
  def add_time_zone_variable
    unless cookies[:time_zone].blank?
      @time_zone = cookies[:time_zone] 
    else
      @time_zone = 'Santiago'
    end
  end
  
  def get_gift_card_value
    gift_card = GiftCard.find_by_barcode params[:barcode]
    respond_to do |format|
      format.json  { render :json => gift_card }
    end

  end
    
  def set_time_zone
    @time_zone = params[:time_zone_name]
    if @time_zone
      cookies[:time_zone] = @time_zone if @time_zone
      render :text => "success"
    else
      render :text => "error"
    end
  end
  
  def check_if_costumer_exists
    type = params[:type]
    value = params[:value]
    if type == 'rut'
      @customer = Customer.find_by_rut(value)
    elsif type == 'email'
      @customer = Customer.find_by_email(value)
    else
      @customer = nil
    end
    
    respond_to do |format|
      format.json  { render :json => @customer }
    end
  end
  
  def search_products_ajax
    sup_acc = SupplierAccount.find params[:supplier_account_id]
    pszs = sup_acc.find_product_stock_sizes(params[:q])
    respond_to do |format|
      format.json  { render :json => pszs.map{|psz| {:image_url => (psz.product.product_images.first.photo.url(:side) if psz.product.product_images.size > 0), :name => psz.product.name, :size =>  psz.size.name, :color =>  psz.color, :barcode =>  psz.barcode, :id =>  psz.id} } }
    end
  end
  
  def search_product_ajax
    pss = ProductStockSize.joins(:product).where('products.supplier_account_id = ? and product_stock_sizes.barcode = ?', params[:supplier_account_id], params[:q]).first
    respond_to do |format|
      format.json  { render :json => {:name => (pss.blank? ? 'Producto No Encontrado' : pss.string_for_select)} }
    end
  end
  
  def is_numeric?(obj) 
     obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
  
end
