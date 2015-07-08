class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :ensure_email_present
  before_action :application_meta_tag
  before_filter { |c| Authorization.current_user = c.current_user }

  def ensure_email_present
    redirect_to change_email_form_user_path(current_user) if current_user && current_user.email.blank?
  end

  def application_meta_tag
    set_meta_tags site: "Baraza",
                  title: "Baraza"
  end
end
