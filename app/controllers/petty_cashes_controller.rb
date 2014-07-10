class PettyCashesController < ApplicationController
  before_action :set_petty_cash, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier_account
  # GET /petty_cashes
  # GET /petty_cashes.json
  def index
    @petty_cashes = @supplier_account.petty_cashes.order 'created_at DESC'
  end

  # GET /petty_cashes/1
  # GET /petty_cashes/1.json
  def show
    
    efectivo = PaymentMethod.where('name like "%efectivo%"').first
    @previous_petty_cash = PettyCash.where('created_at < ?', @petty_cash.created_at).order('created_at DESC').first
    unless @previous_petty_cash.blank?
      @last_petty_cash = @previous_petty_cash
      @payments_before_last = Payment.where('created_at > ? and created_at <= ? and payment_method_id = ?', @previous_petty_cash.created_at, @petty_cash.created_at, efectivo.id)
      @expenses = Expense.where('created_at > ? and created_at <= ? and payment_type = ?', @previous_petty_cash.created_at, @petty_cash.created_at, 'petty_cash')
      @cash_in_petty_cash = @last_petty_cash.close_amount + @payments_before_last.sum(:amount) - @expenses.sum(:amount)
    else
      @payments_before_last = Payment.where('created_at <= ? and payment_method_id = ?', @petty_cash.created_at, efectivo.id)
      @expenses = Expense.where('created_at <= ? and payment_type = ?', @petty_cash.created_at, 'petty_cash')
      @cash_in_petty_cash = @payments_before_last.sum(:amount) - @expenses.sum(:amount)
    end
  end

  # GET /petty_cashes/new
  def new
    @petty_cash = PettyCash.new
    @last_petty_cash = PettyCash.all.order('created_at DESC').first
    efectivo = PaymentMethod.where('name like "%efectivo%"').first
    
    unless @last_petty_cash.blank?
      @payments_before_last = Payment.where('created_at > ? and payment_method_id = ?', @last_petty_cash.created_at, efectivo.id)
      @expenses = Expense.where('created_at > ? and payment_type = ?', @last_petty_cash.created_at, 'petty_cash')
      @cash_in_petty_cash = @last_petty_cash.close_amount + @payments_before_last.sum(:amount) - @expenses.sum(:amount)
    else
      @payments_before_last = Payment.where('payment_method_id = ?', efectivo.id)
      @expenses = Expense.where('payment_type = ?', 'petty_cash')
      @cash_in_petty_cash = @payments_before_last.sum(:amount) - @expenses.sum(:amount)
    end
  end

  # GET /petty_cashes/1/edit
  def edit
  end

  # POST /petty_cashes
  # POST /petty_cashes.json
  def create
    @petty_cash = PettyCash.new(petty_cash_params)

    respond_to do |format|
      if @petty_cash.save
        format.html { redirect_to supplier_account_petty_cashes_url, notice: 'Petty cash was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@supplier_account, @petty_cash] }
      else
        format.html { render action: 'new' }
        format.json { render json: [@supplier_account, @petty_cash].errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /petty_cashes/1
  # PATCH/PUT /petty_cashes/1.json
  def update
    respond_to do |format|
      if @petty_cash.update(petty_cash_params)
        format.html { redirect_to [@supplier_account, @petty_cash], notice: 'Petty cash was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: [@supplier_account, @petty_cash].errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /petty_cashes/1
  # DELETE /petty_cashes/1.json
  def destroy
    @petty_cash.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_petty_cashes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_petty_cash
      @petty_cash = PettyCash.find(params[:id])
    end

    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def petty_cash_params
      params.require(:petty_cash).permit(:close_amount, :supplier_account_id, :user_id)
    end
end
