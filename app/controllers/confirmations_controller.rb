class ConfirmationsController < Devise::ConfirmationsController
  def after_confirmation_path_for (resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      root_path
    end
  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      render json: resource.errors.full_messages.to_sentence, status: 422
    end
  end
end
