class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :change_ticket, :return_product, :destroy]
  before_action :set_supplier_account
  before_action :set_date_range, only: [:index]
  
  # GET /purchases
  # GET /purchases.json
  def index
    @q = params[:q]
    @purchases = @supplier_account.find_purchases(@from, @to, params[:q])
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end
  
  def change_ticket
  end
  
  def return_product
    @shopping_cart_item = ShoppingCartItem.find params[:shopping_cart_item_id]
    @shopping_cart_item.update_attribute :status, 'refunded'
    @shopping_cart_item.product_stock_size.update_attribute :stock, @shopping_cart_item.product_stock_size.stock + 1
    @purchase.update_attribute :status, 'partial refund'
    GiftCard.create(customer_id: @purchase.customer_id, amount: @purchase.reduce_applicable_discount(@shopping_cart_item.product_stock_size.product.price), 
                  valid_until: DateTime.now.in_time_zone(@time_zone).end_of_year, status: 'valid', user_id: current_user.id, supplier_account_id: @supplier_account.id)
    
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to [@supplier_account, @purchase], notice: 'Purchase was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@supplier_account, @purchase] }
      else
        format.html { render action: 'new' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to [@supplier_account, @purchase], notice: 'Purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_purchases_url(supplier_account_id: @supplier_account.id) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end
    
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:payment_method_id, :shopping_cart_id, :supplier_account_id, :paid_amount, :customer_id, :discount, :discount_type, :user_id, :invoice_number, :change_ticket_barcode)
    end

    def set_date_range
      if params[:from].nil? or params[:to].nil?
        @from = DateTime.now.in_time_zone(@time_zone).beginning_of_month
        @to = DateTime.now.in_time_zone(@time_zone).end_of_month
      else
        @from = Time.parse(params[:from]).in_time_zone(@time_zone).beginning_of_day
        @to = Time.parse(params[:to]).in_time_zone(@time_zone).end_of_day
      end
    end
end
