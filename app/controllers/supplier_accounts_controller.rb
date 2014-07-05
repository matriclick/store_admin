# encoding: UTF-8
class SupplierAccountsController < ApplicationController
  autocomplete :user, :email
  autocomplete :customer, :email
  
  before_action :authenticate_admin, except: [:show, :edit, :update, :add_user, :remove_user, :edit_user_privileges, :update_user]
  before_action :set_supplier_account, :check_if_user_has_related_supplier_account, only: [:show, :edit, :update, :destroy, :add_user, :remove_user, :edit_user_privileges, :update_user]

  def add_user
    user = User.where(:email => params[:user_email]).first
    if !user.nil?
      user.supplier_accounts << @supplier_account
      user.save
      redirect_to @supplier_account, notice: 'Usuario agregado exitosamente'
    else
      redirect_to @supplier_account, notice: 'Correo no registrado en el sistema'
    end
  end
  
  def edit_user_privileges
    @user = User.find params[:user_id]
  end
  
  def update_user
    @user = User.find(params[:user_id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user].permit(:store_admin_privilege_ids => []))
        format.html { redirect_to @supplier_account, notice: 'Permisos del usuario actualizados' }
        format.json { head :ok }
      else
        format.html { redirect_to @supplier_accounts, notice: 'Error desconocido' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def remove_user
    user = User.find params[:user_id]
    if !user.nil?
      user.supplier_accounts.delete @supplier_account
      user.role_id = nil
      user.store_admin_privileges.delete StoreAdminPrivilege.all
      user.save
      redirect_to @supplier_account, notice: 'Usuario eliminado exitosamente'
    else
      redirect_to @supplier_account, notice: 'Correo no registrado en el sistema'
    end
  end

  # GET /supplier_accounts
  # GET /supplier_accounts.json
  def index
    @supplier_accounts = SupplierAccount.all
  end

  # GET /supplier_accounts/1
  # GET /supplier_accounts/1.json
  def show
  end

  # GET /supplier_accounts/new
  def new
    @supplier_account = SupplierAccount.new
  end

  # GET /supplier_accounts/1/edit
  def edit
  end

  # POST /supplier_accounts
  # POST /supplier_accounts.json
  def create
    @supplier_account = SupplierAccount.new(supplier_account_params)

    respond_to do |format|
      if @supplier_account.save
        format.html { redirect_to @supplier_account, notice: 'Supplier account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @supplier_account }
      else
        format.html { render action: 'new' }
        format.json { render json: @supplier_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplier_accounts/1
  # PATCH/PUT /supplier_accounts/1.json
  def update
    respond_to do |format|
      if @supplier_account.update(supplier_account_params)
        format.html { redirect_to store_admin_menu_path(id: @supplier_account.id), notice: 'Información Actualizada!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @supplier_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplier_accounts/1
  # DELETE /supplier_accounts/1.json
  def destroy
    @supplier_account.destroy
    respond_to do |format|
      format.html { redirect_to supplier_accounts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_account
      @supplier_account = SupplierAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_account_params
      params.require(:supplier_account).permit(:name, :logo, :purchase_details_mail_text, :store_web, :address)
    end
end
