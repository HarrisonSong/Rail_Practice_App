require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
	def setup
		@user = users(:qiyue)
		@micropost = @user.microposts.build(content: "社会主义好", user_id: @user.id)
	end

	test "should be valid" do
		assert @micropost.valid?
	end

	test "user id should be present" do
		@micropost.user_id = nil
		assert_not @micropost.valid?
	end

	test "content should be present" do 
		@micropost.content = "  "
		assert_not @micropost.valid?
	end

	test "content should be at most 140 chars" do
		@micropost.content = 'a'*141
		assert_not @micropost.valid?
	end

	test "order shuold be most recent micropost first" do
		assert_equal microposts(:most_recent), Micropost.first
	end
end
