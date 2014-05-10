# encoding: UTF-8
require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier_account
  
  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product.product_stock_sizes.each do |psz|
      @barcode_value = psz.generate_barcode
      @full_path = "#{Rails.root}/public/system/barcodes/"+@product.supplier_account.name+'/'+psz.size.name+'_'+psz.color+'_'+@product.id.to_s+"_barcode.png"  
      dir = File.dirname(@full_path)
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      barcode = Barby::EAN13.new(@barcode_value)
      File.open(@full_path, 'w') { |f| f.write barcode.to_png(:margin => 3, :height => 55) }
    end
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

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_products_url }
      format.json { head :no_content }
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
      params.require(:product).permit(:name, :description, :price, :cost, :supplier_account_id, product_category_ids: [], product_images_attributes: [:id, :photo, :_destroy], product_stock_sizes_attributes: [:id, :stock, :size_id, :color, :_destroy])
    end
end
