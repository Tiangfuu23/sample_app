class SessionsController < ApplicationController
  before_action :load_user, only: :create
  before_action :check_authen, only: :create
  before_action :check_activation, only: :create

  REMEMBER_ME = "1".freeze

  # GET: /login
  def new; end

  # POST: /login
  def create
    forwarding_url = session[:forwarding_url]
    reset_session
    log_in @user
    remember_cookies(@user) if params.dig(:session, :remember_me) == REMEMBER_ME
    redirect_back_or forwarding_url || @user
  end

  # DELETE: /logout
  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private
  def load_user
    email = params.dig(:session, :email)&.downcase
    return if @user = User.find_by(email:)

    flash.now[:danger] = t(".invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end

  def check_authen
    return if @user.authenticate(params.dig(:session, :password))

    flash.now[:danger] = t(".invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end

  def check_activation
    return if @user.activated?

    flash[:warning] = t(".account_not_activated")
    redirect_to root_path, status: :see_other
  end
end
