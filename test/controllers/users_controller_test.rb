require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:masato)
    @other_user = users(:kaori)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end

  # 別ユーザの編集画面にアクセスしようとするとルートパスへ遷移するテスト
  test "should redirect edit when logged in wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # 別ユーザの更新処理をしようとするとルートパスへ遷移するテスト
  test "should redirect update when logged in wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

end
