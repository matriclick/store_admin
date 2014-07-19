class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier_account
  # GET /expenses
  # GET /expenses.json
  def index
    if params[:from].nil? or params[:to].nil?
      @all_expenses = @supplier_account.expenses.order 'created_at DESC'
      @expenses = @supplier_account.expenses.paginate(:page => params[:page], :per_page => 15).order 'created_at DESC'
    else
      @from = Time.parse(params[:from]).in_time_zone(@time_zone).beginning_of_day
      @to = Time.parse(params[:to]).in_time_zone(@time_zone).end_of_day
      @all_expenses = @supplier_account.expenses.where('expenses.created_at >= ? and expenses.created_at <= ?', @from, @to).order 'created_at DESC'
      @expenses = @supplier_account.expenses.where('expenses.created_at >= ? and expenses.created_at <= ?', @from, @to).paginate(:page => params[:page], :per_page => 15).order 'created_at DESC'
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)

    respond_to do |format|
      if @expense.save
        format.html { redirect_to [@supplier_account, @expense], notice: 'Expense was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@supplier_account, @expense] }
      else
        format.html { render action: 'new' }
        format.json { render json: [@supplier_account, @expense].errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to [@supplier_account, @expense], notice: 'Expense was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: [@supplier_account, @expense].errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_expenses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end
    
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:amount, :currency_id, :provider_id, :tax_exception, :expense_type_id, :paid_by, :pay_date, :paid, :comments, :supplier_account_id, :payment_type)
    end
end
