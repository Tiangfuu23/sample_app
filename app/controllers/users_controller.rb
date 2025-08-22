class UsersController < ApplicationController
  PAGE_LIMIT = 10

  before_action :logged_in_user,
                only: %i(show edit update destroy index following followers)
  before_action :load_user,
                only: %i(show edit update destroy following followers)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy

  # GET /users/:id
  def show
    @page, @microposts = pagy @user.microposts
                                   .recent
                                   .includes(:user)
                                   .with_attached_image,
                              items: PAGE_LIMIT,
                              limit: PAGE_LIMIT
  end

  # GET /signup
  def new
    @user = User.new
  end

  # POST /signup
  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t(".check_email")
      redirect_to root_path, status: :see_other
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

  # GET /users/:id/following
  def following
    @title = t(".following_title")
    @pagy, @users = pagy(@user.following.includes(:microposts),
                         items: PAGE_LIMIT)
    render "show_follow", status: :unprocessable_entity
  end

  # GET /users/:id/followers
  def followers
    @title = t(".followers_title")
    @pagy, @users = pagy(@user.followers.includes(:microposts),
                         items: PAGE_LIMIT)
    render "show_follow", status: :unprocessable_entity
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
