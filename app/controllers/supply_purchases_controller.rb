class SupplyPurchasesController < ApplicationController
  before_action :set_supply_purchase, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier_account, :set_provider


  def search_product
    #    @q = params[:q]
    #    @products = @supplier_account.find_products(params[:q])
    @products = @supplier_account.products
    respond_to do |format|
      format.json { render json: @products }
    end
  end
  
  # GET /supply_purchases
  # GET /supply_purchases.json
  def index
    @supply_purchases = @provider.supply_purchases
  end

  # GET /supply_purchases/1
  # GET /supply_purchases/1.json
  def show
  end

  # GET /supply_purchases/new
  def new
    @supply_purchase = SupplyPurchase.new
    @supply_purchase.supply_purchase_product_sizes.build(quantity: params[:psz_stock], product_stock_size_barcode: params[:barcode])
    @supply_purchase.supply_purchase_payments.build
  end

  # GET /supply_purchases/1/edit
  def edit
  end

  # POST /supply_purchases
  # POST /supply_purchases.json
  def create
    @supply_purchase = SupplyPurchase.new(supply_purchase_params)

    respond_to do |format|
      if @supply_purchase.save
        format.html { redirect_to [@supplier_account, @provider, @supply_purchase], notice: 'Supply purchase was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@supplier_account, @provider, @supply_purchase] }
      else
        format.html { render action: 'new' }
        format.json { render json: @supply_purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supply_purchases/1
  # PATCH/PUT /supply_purchases/1.json
  def update
    respond_to do |format|
      if @supply_purchase.update(supply_purchase_params)
        format.html { redirect_to [@supplier_account, @provider, @supply_purchase], notice: 'Supply purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @supply_purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supply_purchases/1
  # DELETE /supply_purchases/1.json
  def destroy
    @supply_purchase.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_provider_supply_purchases_url(supplier_account_id: @supplier_account.id, provider_id: @provider.id) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supply_purchase
      @supply_purchase = SupplyPurchase.find(params[:id])
    end
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end
    def set_provider
      @provider = Provider.find(params[:provider_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supply_purchase_params
      params.require(:supply_purchase).permit(:provider_id, :comments, supply_purchase_product_sizes_attributes: [:id, :quantity, :barcode, :product_stock_size_barcode, :update_stock, :unit_cost, :currency_id, :_destroy], supply_purchase_payments_attributes: [:id, :amount, :pay_date, :paid, :currency_id, :_destroy])
    end
end
