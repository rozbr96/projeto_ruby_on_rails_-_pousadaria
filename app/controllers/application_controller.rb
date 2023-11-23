class ApplicationController < ActionController::Base
  add_flash_types :warning, :info

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_inn_creation_page
  before_action :set_search


  protected

  def after_sign_in_path_for resource
    return new_guest_booking_path if guest_signed_in? and session[:booking]

    stored_location_for(resource) || super
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name, :citizen_number]
  end

  def redirect_to_inn_creation_page
    whitelist_routes = new_host_inn_path, destroy_innkeeper_session_path

    return if whitelist_routes.include? request.fullpath
    return if request.fullpath == host_inn_path and request.method_symbol == :post
    return unless innkeeper_signed_in?
    return unless current_innkeeper.inn.nil?

    redirect_to new_host_inn_path, warning: 'Primeiro é necessário registrar sua pousada!'
  end

  def set_search
    @search = AdvancedSearch.new search_in_city: false,
      search_in_description: false,
      search_in_name: false,
      search_in_neighbourhood: false,
      with_accessibility_for_disabled_people: :indifferent,
      with_air_conditioning: :indifferent,
      with_balcony: :indifferent,
      with_pets_allowed: :indifferent,
      with_vault: :indifferent,
      with_tv: :indifferent
  end
end
