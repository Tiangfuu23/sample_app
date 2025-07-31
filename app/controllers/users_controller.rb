class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    Rails.logger.debug params.inspect

    @user = User.new user_params

    if @user.save
      # Handle a successful save.
      flash[:success] = t(".success_message") # TODO: i18m
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

end
