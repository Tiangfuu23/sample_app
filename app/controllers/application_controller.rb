class ApplicationController < ActionController::Base
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
end
