require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
	def setup 
		@user = users(:qiyue)
	end

	test "layout_links" do
		
		# test non-logged in behaviors
		get root_path
		assert_template 'static_pages/home'
		assert_select "a[href=?]", root_path , count:2
		assert_select "a[href=?]", about_path
		assert_select "a[href=?]", help_path
		assert_select "a[href=?]", contact_path

		# test logged in behaviors
		log_in_as(@user)
		get root_path
		assert_template 'static_pages/home'
		assert_select "a[href=?]", root_path , count:2
		assert_select "a[href=?]", about_path
		assert_select "a[href=?]", help_path
		assert_select "a[href=?]", contact_path
		assert_select "a[href=?]", user_path(@user)
		assert_select "a[href=?]", edit_user_path(@user)
		assert_select "a[href=?]", logout_path
	end

	test "signup_links" do
		get signup_path
		assert_template 'users/new'
		assert_select "a[href=?]", root_path , count:2
		assert_select "a[href=?]", about_path
		assert_select "a[href=?]", help_path
		assert_select "a[href=?]", contact_path
		assert_select "title", full_title("Sign up")
	end
end
