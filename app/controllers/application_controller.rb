class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	include SessionsHelper

	private 

  	# Confirms a logged-in user.
  	def logged_in_user
		# logged_in? is a method in sessions helper. It is available here because
		# the sessionshelper is included in ApplicationController and users_controller
		# is inherited from ApplicationController.
		unless logged_in?
			store_location
			flash[:danger] = "Please log in."
			redirect_to login_url
		end
	end
end
