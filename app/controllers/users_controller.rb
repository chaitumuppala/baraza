class UsersController < ApplicationController
  before_action :set_user
  skip_before_action :authenticate

  def edit
  end

  def update
    if(@user.update_email(params[:user][:email]))
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