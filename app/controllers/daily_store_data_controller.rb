class DailyStoreDataController < ApplicationController
  before_action :set_daily_store_datum, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier_account
  # GET /daily_store_data
  # GET /daily_store_data.json
  def index
    @daily_store_data = @supplier_account.daily_store_datum
  end

  # GET /daily_store_data/1
  # GET /daily_store_data/1.json
  def show
  end

  # GET /daily_store_data/new
  def new
    @daily_store_datum = DailyStoreDatum.new
  end

  # GET /daily_store_data/1/edit
  def edit
  end

  # POST /daily_store_data
  # POST /daily_store_data.json
  def create
    @daily_store_datum = DailyStoreDatum.new(daily_store_datum_params)

    respond_to do |format|
      if @daily_store_datum.save
        format.html { redirect_to [@supplier_account, @daily_store_datum], notice: 'Daily store datum was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@supplier_account, @daily_store_datum] }
      else
        format.html { render action: 'new' }
        format.json { render json: @daily_store_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /daily_store_data/1
  # PATCH/PUT /daily_store_data/1.json
  def update
    respond_to do |format|
      if @daily_store_datum.update(daily_store_datum_params)
        format.html { redirect_to [@supplier_account, @daily_store_datum], notice: 'Daily store datum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @daily_store_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /daily_store_data/1
  # DELETE /daily_store_data/1.json
  def destroy
    @daily_store_datum.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_daily_store_data_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_store_datum
      @daily_store_datum = DailyStoreDatum.find(params[:id])
    end
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daily_store_datum_params
      params.require(:daily_store_datum).permit(:date, :came_in_clients, :supplier_account_id, :comments)
    end
end
