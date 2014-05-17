# encoding: UTF-8
class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :add_time_zone_variable, except: [:set_time_zone]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
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
      format.json  { render :json => pszs.map{|psz| {:image_url =>  psz.product.product_images.first.photo.url(:side), :name => psz.product.name, :size =>  psz.size.name, :color =>  psz.color, :barcode =>  psz.barcode, :id =>  psz.id} } }
    end
  end
  
end
