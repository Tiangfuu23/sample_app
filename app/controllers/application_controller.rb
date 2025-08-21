class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale

  private

  def set_locale
    I18n.locale = if params[:locale].present? &&
                     I18n.available_locales.include?(params[:locale].to_sym)
                    params[:locale]
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:warning] = t("users.logged_in_user.please_log_in")
    redirect_to login_path, status: :see_other
  end
end
