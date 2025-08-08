module SessionsHelper
  # Logs in the given user
  def log_in user
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end

  # Returns the current logged-in user (if any)
  def current_user
    @current_user ||= user_from_session || user_from_cookies
  end

  # Returns true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget current_user
    reset_session
    @current_user = nil
  end

  def remember_cookies user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  private
  def user_from_session
    return unless (user_id = session[:user_id])

    user = User.find_by id: user_id
    user if user&.authenticated?(session[:session_token])
  end

  def user_from_cookies
    return unless (user_id = cookies.signed[:user_id])

    user = User.find_by id: user_id
    return unless user&.authenticated?(cookies[:remember_token])

    log_in user
    user
  end

  def current_user? user
    user == current_user
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end
end
