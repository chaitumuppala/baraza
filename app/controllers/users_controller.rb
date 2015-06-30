class UsersController < ApplicationController
  before_action :set_user
  skip_before_action :ensure_email_present, only: [:change_email, :change_email_form]
  filter_resource_access

  def change_email_form
  end

  def change_email
    if(@user.update_email(params[@user.type.underscore.to_sym][:email]))
      redirect_to root_path
    else
      render :change_email_form
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit!
  end
end