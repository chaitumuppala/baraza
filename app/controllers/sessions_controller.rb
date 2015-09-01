class SessionsController < Devise::SessionsController
  skip_before_action :ensure_email_present
end
