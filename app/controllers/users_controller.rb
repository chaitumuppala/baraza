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
        # TODO: Vijay: Move this to a after_save hook on the model
        TypeChangeNotifier.public_send("change_type_to_#{user_params[:type].underscore}_mail", @user.email, @user.full_name).deliver_now
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors.full_messages.to_sentence, status: :unprocessable_entity }
      end
    end
  end

  def change_email_form
  end

  def change_email
    email_value = params[@user.type.underscore.to_sym][:email]
    if email_value.present? && @user.update_attributes(email: email_value)
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
