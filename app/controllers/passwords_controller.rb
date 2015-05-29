class PasswordsController < Devise::PasswordsController
  def create
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