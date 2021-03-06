# encoding: UTF-8
require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :update_barcode, :distribute_stock, :update_distribution, :barcodes]
  before_action :set_supplier_account, :check_if_user_has_related_supplier_account
  
  # GET /products
  # GET /products.json
  def index
    @q = params[:q]
    @all_products = @supplier_account.find_products(params[:q]).order 'created_at DESC'
    @products = @supplier_account.find_products(params[:q]).paginate(:page => params[:page], :per_page => 15).order 'created_at DESC'
    respond_to do |format|
      format.html
      format.xls
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @warehouse_product_size_stocks = WarehouseProductSizeStock.joins(:product_stock_size).where("product_stock_sizes.product_id = ?", @product.id)
    @default_provider = Provider.find_by_name('Sin Proveedor')
  end

  def barcodes
    @quantity = is_numeric?(params[:quantity]) ? params[:quantity].to_i : nil
  end
  
  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        #send_product_data_via_post_to_ecommerce(@product)
        format.html { redirect_to supplier_account_product_path(supplier_account_id: @supplier_account.id, id: @product.id), notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to supplier_account_product_path(supplier_account_id: @supplier_account.id, id: @product.id), notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #PUT
  def update_barcode
    @product_stock_size = ProductStockSize.find params[:product_stock_size_id]
    
    respond_to do |format|
      if @product_stock_size.assign_manual_barcode(params[:barcode])
        format.html { redirect_to supplier_account_product_path(supplier_account_id: @supplier_account.id, id: @product.id), notice: 'Código de barras actualizado.' }
        format.json { head :no_content }
      else
        format.html { redirect_to supplier_account_product_path(supplier_account_id: @supplier_account.id, id: @product.id), notice: 'Error: Código en formato EAN-13 incorrecto.' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_products_url }
      format.json { head :no_content }
    end
  end

  def import
    col_sep = ','
    if Product.import(params[:file], col_sep, @supplier_account)
      redirect_to supplier_account_products_path, notice: "Productos Importados"
    else
      redirect_to supplier_account_products_path, alert: "Error en el formato del archivo; revísalo. Si necesitas ayuda envía un correo a ups@inventariolibre.com"
    end
  end
  
  def distribute_stock
    @product.product_stock_sizes.each do |psz|
      @product.supplier_account.warehouses.each do |warehouse|
        if WarehouseProductSizeStock.where("product_stock_size_id = ? and warehouse_id = ?", psz.id, warehouse.id).size == 0
          WarehouseProductSizeStock.create(:product_stock_size_id => psz.id, :warehouse_id => warehouse.id)
        end
      end
    end
    @warehouse_product_size_stocks = WarehouseProductSizeStock.joins(:product_stock_size).where("product_stock_sizes.product_id = ?", @product.id)
  end
  
  def update_distribution
    distributed_ok = true
    #Distribute Stock
    warehouse_product_size_stock_ids = params[:stock]
    warehouse_product_size_stock_ids.each do |id|
      wpss = WarehouseProductSizeStock.find(id[0])
      wpss.update_attribute :stock, id[1]
    end
    #Check if distribution is OK
    @product.product_stock_sizes.each do |psz|
      distributed_ok = false if WarehouseProductSizeStock.where('product_stock_size_id = ?', psz.id).sum(:stock) != psz.stock
    end
    
    if distributed_ok
      redirect_to supplier_account_product_path(supplier_account_id: @supplier_account.id, id: @product.id), notice: 'Stock distribuido OK.'
    else
      redirect_to supplier_account_product_distribute_stock_path(supplier_account_id: @supplier_account.id, id: @product.id), alert: '¡La distribución entre bodegas debe sumar el stock total para todas las tallas!'
    end
  end
  
  def send_product_data_via_post_to_ecommerce(product)
    require "net/http"
    require "uri"
    
    uri = URI.parse("http://localhost:3000/users/sign_up/")
    args = {apikey: 'zKDvkvmusejH4tn1XBoh5w', token: session[:junta], object_id: @product.id, name: @product.name  }
    uri.query = URI.encode_www_form(args)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    
    if response.code == '200'
      # Everything OK
    else
      # Oops...
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end
    
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :cost, :provider_id, :supplier_account_id, product_category_ids: [], product_images_attributes: [:id, :photo, :_destroy], product_stock_sizes_attributes: [:id, :stock, :size_id, :color, :warehouse_id, :internal_code, :_destroy])
    end
end
