class ExpenseTypesController < ApplicationController
  before_action :set_expense_type, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier_account

  # GET /expense_types
  # GET /expense_types.json
  def index
    @expense_types = @supplier_account.expense_types
  end

  # GET /expense_types/1
  # GET /expense_types/1.json
  def show
  end

  # GET /expense_types/new
  def new
    @expense_type = ExpenseType.new
  end

  # GET /expense_types/1/edit
  def edit
  end

  # POST /expense_types
  # POST /expense_types.json
  def create
    @expense_type = ExpenseType.new(expense_type_params)

    respond_to do |format|
      if @expense_type.save
        format.html { redirect_to [@supplier_account, @expense_type], notice: 'Expense type was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@supplier_account, @expense_type] }
      else
        format.html { render action: 'new' }
        format.json { render json:  [@supplier_account, @expense_type].errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expense_types/1
  # PATCH/PUT /expense_types/1.json
  def update
    respond_to do |format|
      if @expense_type.update(expense_type_params)
        format.html { redirect_to [@supplier_account, @expense_type], notice: 'Expense type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: [@supplier_account, @expense_type].errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expense_types/1
  # DELETE /expense_types/1.json
  def destroy
    @expense_type.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_expense_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense_type
      @expense_type = ExpenseType.find(params[:id])
    end
    
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_type_params
      params.require(:expense_type).permit(:name, :description, :supplier_account_id)
    end
end
