require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup 
		@newUser = User.new(email:'harrisonsong199@gmail.com', name:'Qiyue Song',
							password: "foobar", password_confirmation: "foobar")	
	end	

	test "Should be valid" do
		assert @newUser.valid?
	end

	test "Name should not be empty" do 
		@newUser.name = ''
		assert_not @newUser.valid?
	end

	test "Email should not be empty" do 
		@newUser.email = '    '
		assert_not @newUser.valid?
	end

	test "Name is too long" do
		@newUser.name = 'a' * 51
		assert_not @newUser.valid?
	end

	test "Email is too long" do
		@newUser.email = 'a' * 244 + 'exmaple.com'
		assert_not @newUser.valid?
	end

	test "Email validation should accept valid addresses" do 
		valid_addresses = %w[userexample,com Userfoo.COM A_US-ERfoo.bar.org first.lastfoo.jp alice+bobbaz.cn  foo@bar..com]
		valid_addresses.each do |valid_address|
			@newUser.email = valid_address
			assert_not @newUser.valid?, "#{valid_address.inspect} should be valid"
		end
	end	

	test "Email addresses should be unique" do
		duplicate_user = @newUser.dup
		duplicate_user.email = @newUser.email.upcase
		@newUser.save
		assert_not duplicate_user.valid?
	end	

	test "Password length should have a minimum length" do
		@newUser.password = @newUser.password_confirmation = 'a' * 4
		assert_not @newUser.valid?
	end

	test "Email addresses should be saved as lower-case" do
		mixed_case_email = "fioejoEDS@FEOIewfo.com"
		@newUser.email = mixed_case_email
		@newUser.save
		assert_equal mixed_case_email.downcase, @newUser.email
	end

	test "authenicated? should return false for a user with nil digest" do
		assert_not @newUser.authenticated?(:remember, '')
	end

	test "associated microposts should be destroyed" do
		@newUser.save
		@newUser.microposts.create!(content: "Mr. Qiyue")
		assert_difference "Micropost.count", -1 do
			@newUser.destroy
		end
	end

	test "should follow and unfollow a user" do
		qiyue = users(:qiyue)
		archer = users(:archer)
		assert_not qiyue.following?(archer)
	    qiyue.follow(archer)
	    assert qiyue.following?(archer)
	    assert archer.followers.include?(qiyue)
	    qiyue.unfollow(archer)
    	assert_not qiyue.following?(archer)
	end

	test "feed should have the right posts" do
		qiyue = users(:qiyue)
		archer = users(:archer)
		lana = users(:lana)
		# Posts from followed user
		lana.microposts.each do |post_following|
			assert qiyue.feed.include?(post_following)
		end

		# Posts from self
		qiyue.microposts.each do |post_self|
			assert qiyue.feed.include?(post_self)
		end

		# Posts from unfollowed user
		archer.microposts.each do |post_unfollowed| 
			assert_not qiyue.feed.include?(post_unfollowed)
		end
	end
end
