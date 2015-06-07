require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	def setup
		ActionMailer::Base.deliveries.clear
	end

	test 'invalid signup' do
		get signup_path
		assert_no_difference 'User.count' do 
	 		post users_path, user: {name: "", email: "user@invalid", password: "foo", password_confirmation: "bar"}
	 	end
	 	assert_template 'users/new'
	 	assert_select 'div#error_explanation'
	 	assert_select 'div.field_with_errors'
	end

	test 'valid signup with account activation' do
		get signup_path
		assert_difference 'User.count', 1 do
			post users_path, user: {name: "Qiyue", email:"harrison1991@qq.com", password:"$Harrison1990", password_confirmation:"$Harrison1990"}
		end
		assert_equal 1, ActionMailer::Base.deliveries.size
		user = assigns(:user)
		assert_not user.activated?
		# Try to log in before activation.
		log_in_as(user)
		assert_not is_logged_in?
		# Invalid activation token
		get edit_activation_path("invalid token")
		assert_not is_logged_in?
		# Valid token, wrong email
		get edit_activation_path(user.activation_token, email: 'wrong')
		assert_not is_logged_in?
		# Valid token and email
		get edit_activation_path(user.activation_token, email:user.email)
		assert user.reload.activated?
		follow_redirect!
		assert_template 'users/show'
		assert is_logged_in?
	end	
end
