class PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.where(email: params[:user][:email]).first
    # render "users/passwords/new" and return if self.resource.try(:has_a_provider?)
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end

  def edit
    reset_password_token = Devise.token_generator.digest(User, :reset_password_token, params[:reset_password_token])
    self.resource = resource_class.find_or_initialize_with_error_by(:reset_password_token, reset_password_token)
    if resource.errors.empty?
      self.resource = resource_class.new
      resource.reset_password_token = params[:reset_password_token]
    else
      flash[:error] = 'Reset password token is invalid'.freeze
    end
  end
end
