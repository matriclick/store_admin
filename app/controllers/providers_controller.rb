class ProvidersController < ApplicationController
  before_action :set_provider, only: [:show, :edit, :update, :destroy]
  before_action :set_supplier_account
  # GET /providers
  # GET /providers.json
  def index
    @providers = @supplier_account.providers
  end

  # GET /providers/1
  # GET /providers/1.json
  def show
  end

  # GET /providers/new
  def new
    @provider = Provider.new
  end

  # GET /providers/1/edit
  def edit
  end

  # POST /providers
  # POST /providers.json
  def create
    @provider = Provider.new(provider_params)

    respond_to do |format|
      if @provider.save
        format.html { redirect_to [@supplier_account, @provider], notice: 'Provider was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@supplier_account, @provider] }
      else
        format.html { render action: 'new' }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /providers/1
  # PATCH/PUT /providers/1.json
  def update
    respond_to do |format|
      if @provider.update(provider_params)
        format.html { redirect_to [@supplier_account, @provider], notice: 'Provider was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /providers/1
  # DELETE /providers/1.json
  def destroy
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to supplier_account_providers_url(supplier_account_id: @supplier_account.id) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider
      @provider = Provider.find(params[:id])
    end
    
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:supplier_account_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_params
      params.require(:provider).permit(:name, :address, :country, :supplier_account_id)
    end
end
