# encoding: UTF-8
class GiftCardsController < ApplicationController
  before_action :set_gift_card, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier_account
  before_action :set_default_breadcrumbs
  # GET /gift_cards
  # GET /gift_cards.json
  def index
    @gift_cards = @supplier_account.gift_cards.order 'created_at DESC'
  end

  # GET /gift_cards/1
  # GET /gift_cards/1.json
  def show
  end

  # GET /gift_cards/new
  def new
    @gift_card = GiftCard.new
  end

  # GET /gift_cards/1/edit
  def edit
  end

  # POST /gift_cards
  # POST /gift_cards.json
  def create
    @gift_card = GiftCard.new(gift_card_params)

    respond_to do |format|
      if @gift_card.save
        format.html { redirect_to [@supplier_account, @gift_card], notice: 'Gift card was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@supplier_account, @gift_card] }
      else
        format.html { render action: 'new' }
        format.json { render json: @gift_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gift_cards/1
  # PATCH/PUT /gift_cards/1.json
  def update
    respond_to do |format|
      if @gift_card.update(gift_card_params)
        format.html { redirect_to [@supplier_account, @gift_card], notice: 'Gift card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gift_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gift_cards/1
  # DELETE /gift_cards/1.json
  def destroy
    @gift_card.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_gift_cards_url }
      format.json { head :no_content }
    end
  end

  private
  
    def set_default_breadcrumbs
      add_breadcrumb "Menú de Configuración", store_admin_menu_path(id: @supplier_account.id)
      add_breadcrumb "GiftCards", supplier_account_gift_cards_path(supplier_account_id: @supplier_account.id)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_gift_card
      @gift_card = GiftCard.find(params[:id])
    end
    
    
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gift_card_params
      params.require(:gift_card).permit(:customer_id, :barcode, :amount, :valid_until, :status, :user_id, :supplier_account_id)
    end
end
