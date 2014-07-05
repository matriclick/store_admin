# encoding: UTF-8
class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier_account
  # GET /customers
  # GET /customers.json
  def index
    if params[:from].nil? or params[:to].nil?
      @all_customers = @supplier_account.find_customers(params[:q]).order('created_at DESC')
      @customers = @supplier_account.find_customers(params[:q]).order('created_at DESC').paginate(:page => params[:page], :per_page => 15)
    else
      @from = Time.parse(params[:from]).in_time_zone(@time_zone).beginning_of_day
      @to = Time.parse(params[:to]).in_time_zone(@time_zone).end_of_day
      @all_customers = @supplier_account.find_customers(params[:q]).order('created_at DESC')
      @customers = @supplier_account.find_customers(params[:q], @from, @to).order('created_at DESC').paginate(:page => params[:page], :per_page => 15)
    end
    respond_to do |format|
      format.html
      format.xls
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @purchases = @customer.purchases
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to [@supplier_account, @customer], notice: 'Customer was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@supplier_account, @customer] }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to [@supplier_account, @customer], notice: 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_customers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :rut, :birthday, :phone_number, :supplier_account_id, :email)
    end
    
end
