class ApplicationController < ActionController::Base
  add_flash_types :warning, :info

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_inn_creation_page


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name]
  end

  def redirect_to_inn_creation_page
    whitelist_routes = new_own_inn_path, destroy_innkeeper_session_path

    return if whitelist_routes.include? request.fullpath
    return if request.fullpath == own_inn_path and request.method_symbol == :post
    return unless innkeeper_signed_in?
    return unless current_innkeeper.inn.nil?

    redirect_to new_own_inn_path, warning: 'Primeiro é necessário registrar sua pousada!'
  end
end
