class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :ensure_email_present
  before_action :application_meta_tag
  before_filter { |c| Authorization.current_user = c.current_user }

  def permission_denied
    flash[:alert] = "Sorry, you are not allowed to access that page.".freeze;
    session[:user_return_to] = request.fullpath
    path = Authorization.current_user.role_symbols.include?(:guest) ? new_user_session_path : root_path
    redirect_to path
  end

  def ensure_email_present
    redirect_to change_email_form_user_path(current_user) if current_user && current_user.email.blank?
  end

  def application_meta_tag
    set_meta_tags site: "Baraza".freeze,
                  title: "Baraza".freeze
  end

  protected
  def after_sign_in_path_for(resource)
    return_path = session[:user_return_to]
    session[:user_return_to] = nil
    if return_path && article_show_url(return_path)
      return_path
    else
      super
    end
  end

  private
  def article_show_url(url)
    url_info = Rails.application.routes.recognize_path(url)
    url_info[:controller] == "articles".freeze && url_info[:action] == "show".freeze
  end
end
