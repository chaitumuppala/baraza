class SessionsController < Devise::RegistrationsController
  skip_before_action :ensure_email_present
end