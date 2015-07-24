class PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.where(email: params[:user][:email]).first
    render "users/passwords/new" and return if self.resource.try(:has_a_provider?)
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end
end