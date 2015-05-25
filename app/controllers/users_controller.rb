class UsersController < ApplicationController
  before_action :set_user
  skip_before_action :ensure_email_present
  filter_resource_access

  def edit
  end

  def update
    if(@user.update_email(params[:registered_user][:email]))
      redirect_to root_path
    else
      render :edit
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