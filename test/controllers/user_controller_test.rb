require 'test_helper'

class UsersControllerTest < ActionController::TestCase
	def setup
		@user = users(:qiyue)
		@second_user = users(:harrison)
	end

	test "should get new" do
		get :new
		assert_response :success
	end

	test "should redirect edit when not logged in" do
		get :edit, id:@user.id
		assert_not flash.empty?
		assert_redirected_to login_url
	end

	test "should redirect update when not logged in" do
		get :update, id:@user.id, user:{name: @user.name,
										email: @user.email}
		assert_not flash.empty?
		assert_redirected_to login_url								
	end

	test "should redirect edit when logged in as wrong user" do
		log_in_as(@second_user)
		get :edit, id:@user.id
		assert flash.empty?
		assert_redirected_to root_url
	end

	test "should redirect update when logged in as wrong user" do
		log_in_as(@second_user)
		get :update, id:@user.id, user:{name:@user.name, email:@user.email}
		assert flash.empty?
		assert_redirected_to root_url
	end

	test "should not allow the admin attribute to be edited via the web" do
		log_in_as(@second_user)
		assert_not @second_user.admin?
		patch :update, id: @second_user, user:{password: "password",
											  password_confirmation: "password",
											  admin: true}
	    assert_not @second_user.reload.admin?
	end

	test "should redirect index when not logged in" do
		get :index
		assert_redirected_to login_url
	end

	test "should redirect destroy when ont logged in" do
		assert_no_difference 'User.count' do
			delete :destroy, id:@user
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy when logged in as a non-admin" do
		log_in_as(@second_user)
		assert_no_difference 'User.count' do
			delete :destroy, id:@user
		end
		assert_redirected_to root_url
	end

	test "should redirect following when not logged in" do
		get :following, id: @user
		assert_redirected_to login_url
	end

	test "should redirect followers when not logged in" do
		get :followers, id: @user
		assert_redirected_to login_url
	end
end
