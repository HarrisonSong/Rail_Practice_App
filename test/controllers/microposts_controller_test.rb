require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
	def setup
		@micropost = microposts(:orange)
	end

	test "should redirect create when not logged in" do
		assert_no_difference 'Micropost.count' do
			post :create, micropost: {content: "haha this is just a test."}
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy when not logged in" do
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: @micropost.id
		end
		assert_redirected_to login_url
	end

	test "shuold redirect destroy for wrong micropost" do
		log_in_as(users(:qiyue))
		micropost = microposts(:ants)
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: micropost
		end
		assert_redirected_to root_url
	end
end