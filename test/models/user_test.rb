require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", 
    password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email address should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should be present (nonblank) " do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have minimum length " do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest " do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do 
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    masato = users(:masato)
    kaori = users(:kaori)
    assert_not masato.following?(kaori)
    masato.follow(kaori)
    assert masato.following?(kaori)
    assert kaori.followers.include?(masato)
    masato.unfollow(kaori)
    assert_not masato.following?(kaori)
  end
  
  test "feed should have the right posts" do
    masato = users(:masato)
    kaori = users(:kaori)
    ichiro = users(:ichiro)
    # フォローしているユーザの投稿を確認
    ichiro.microposts.each do |post_following|
      assert masato.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    masato.microposts.each do |post_self|
      assert masato.feed.include?(post_self)
    end
    # フォローしていないユーザの投稿を確認
    kaori.microposts.each do |post_followed|
      assert_not masato.feed.include?(post_followed)
    end
  end
end
