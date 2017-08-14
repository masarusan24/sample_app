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

  # 未ログイン状態の時インデックスに遷移するテスト
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
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
  
  # WEBから直接PATCHリクエストを送信しても管理者権限を付与しない
  test "should not allow the addmin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                  user: { password: @other_user.password,
                                  password_confirmation: @other_user.password,
                                  addmin: true }  }
    assert_not @other_user.reload.admin?
  end
  
  # 未ログインユーザはログイン画面にリダイレクトする
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  # 非管理者ユーザはルート画面にリダイレクトする
  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  # 未ログインユーザはログイン画面にリダイレクトする
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end
  
  # 未ログインユーザはログイン画面にリダイレクトする
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
