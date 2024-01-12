class ApplicationController < ActionController::Base
  before_action :set_current_user_ip_address

  private
    def set_current_user_ip_address
      session[:ip_address] ||= SecureRandom.urlsafe_base64(16)
      # Current.ip_address = request.ip # This will not work in production
      Current.ip_address = session[:ip_address]
    end
end
