class SessionsController < Devise::RegistrationsController
  skip_before_action :authenticate
end