class ApplicationController < ActionController::Base
  before_action :set_current_user_ip_address

  private

    def set_current_user_ip_address
      Current.ip_address = request.ip
    end
end
