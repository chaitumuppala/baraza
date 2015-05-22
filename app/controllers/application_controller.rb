class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate
  before_filter { |c| Authorization.current_user = c.current_user }

  def authenticate
    redirect_to user_edit_path(current_user) if current_user && current_user.email.blank?
  end
end
