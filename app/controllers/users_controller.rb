class UsersController < ApplicationController
  PAGE_LIMIT = 10

  before_action :logged_in_user, only: %i(show edit update destroy index)
  before_action :load_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy

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

  # GET /users
  def index
    @pagy, @users = pagy(User.newest, items: PAGE_LIMIT, limit: PAGE_LIMIT)
  end

  # GET /users/:id/edit
  def edit; end

  # PATCH|PUT /users/:id
  def update
    if @user.update user_params
      flash[:success] = t(".success_message")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    if @user.destroy
      flash[:success] = t(".success_message")
    else
      flash[:danger] = t(".error_message")
    end

    redirect_to users_path, status: :see_other
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

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("users.logged_in_user.please_log_in")
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t("users.current_user.not_authorized")
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t("users.admin_user.not_authorized")
    redirect_to root_path, status: :see_other
  end
end
