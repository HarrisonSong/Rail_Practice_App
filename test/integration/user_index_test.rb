require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
	def setup
		@admin = users(:qiyue)
		@normal_user = users(:harrison)
	end

	test "index as admin include pagination and delete links" do
		log_in_as(@admin)
		get users_path
		assert_template 'users/index'
		assert_select 'div.pagination'
		first_page_of_users = User.paginate(page: 1)
		first_page_of_users.each do |user|
			assert_select 'a[href=?]', user_path(user), text: user.name
			unless user == @admin	
				assert_select 'a[href=?]', user_path(user), text: 'delete', method: :delete
			end 
		end
		assert_difference 'User.count', -1 do
			delete user_path(@normal_user)
		end
	end

	test "index as non-admin" do
		log_in_as(@normal_user)
		get users_path
		assert_select 'a', text: 'delete', count: 0
	end

	test "User that is not activated should not be display in index page" do
		log_in_as(@admin)
		@normal_user.toggle!(:activated)
		get users_path
		assert_select 'a[href=?]', user_path(@normal_user), count: 0
	end

	test "User that is not activated should not be accessed" do
		log_in_as(@normal_user)
		@normal_user.toggle!(:activated)
		get user_path(@normal_user)
		assert_redirected_to root_url
	end
end
