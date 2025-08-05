class UsersController < ApplicationController
  before_action :load_user, only: :show

  # GET /users/:id
  def show; end

  # GET /signup
  def new
    @user = User.new
  end

  # POST /signup
  def create
    @user = User.new user_params

    if @user.save
      reset_session
      log_in @user
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

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path
  end
end
