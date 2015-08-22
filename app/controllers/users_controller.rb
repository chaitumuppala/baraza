class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :change_email, :change_email_form]
  skip_before_action :ensure_email_present, only: [:change_email, :change_email_form]
  filter_resource_access

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    type = @user.type.underscore
    user_params = params.require(type).permit(:first_name, :last_name, :type, :email)
    respond_to do |format|
      if @user.update(user_params)
        TypeChangeNotifier.send("change_type_to_#{user_params[:type].underscore}_mail", @user.email, @user.full_name, @user.type).deliver_now
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_email_form
  end

  def change_email
    email_value = params[@user.type.underscore.to_sym][:email]
    if (email_value.present? && @user.update_attributes(email: email_value))
      redirect_to root_path
    else
      render :change_email_form
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
end
