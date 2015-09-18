class PasswordsController < Devise::PasswordsController
  def edit
    reset_password_token = Devise.token_generator.digest(User, :reset_password_token, params[:reset_password_token])
    self.resource = resource_class.find_or_initialize_with_error_by(:reset_password_token, reset_password_token)
    if resource.errors.empty?
      self.resource = resource_class.new
      resource.reset_password_token = params[:reset_password_token]
    else
      flash[:error] = 'Reset password token is invalid'
    end
  end
end
