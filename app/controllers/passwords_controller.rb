class PasswordsController < Devise::PasswordsController
  def create
    user = resource_class.where(email: params[:user][:email]).first
    render json: "Email not found", status: 422 and return if user.try(:has_a_provider?)
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      render json: resource.errors.full_messages.to_sentence, status: 422
    end
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    root_path
  end
end