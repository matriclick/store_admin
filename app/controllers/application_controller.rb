# encoding: UTF-8
class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :add_time_zone_variable, except: [:set_time_zone]
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def authenticate_admin
    unless current_user.is_admin?
      redirect_to root_path, notice: 'No tienes permisos para acceder a esta sección'
    end
  end
  
  def add_time_zone_variable
    unless cookies[:time_zone].blank?
      @time_zone = cookies[:time_zone] 
    else
      @time_zone = 'Santiago'
    end
  end
  
  def set_time_zone
    @time_zone = params[:time_zone_name]
    if @time_zone
      cookies[:time_zone] = @time_zone if @time_zone
      render :text => "success"
    else
      render :text => "error"
    end
  end
  
end
