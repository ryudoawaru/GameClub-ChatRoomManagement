# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
	prepend_before_filter :auth_login
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

protected

  def autofill_params(ph)
    ph.each do |key, val|
      next if val.is_a?(Hash)
      if params[key.to_sym].blank?
        params[key.to_sym] = val
      end
    end
  end

	def auth_login
		authenticate_or_request_with_http_basic do |user_name, password|
    	@login_admin = DzMember.confirm_administrator_login(user_name, password)
    end
	end

	def choice_room
		@room = Channel.find(params[:room_id].to_i)
	end
  
end
