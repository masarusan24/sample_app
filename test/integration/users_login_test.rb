require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup 
    @user = users(:masato)
  end
  
  # 正しい情報でログイン
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: {email:@user.email, password:'password'}}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
 
  # ログインエラーの挙動テスト
  test "login with invalid information" do 
    get login_path  # ログインページに飛ぶ
    assert_template 'sessions/new'  # フォームが正しくレンダリングされる
    post login_path, params: { session: {email: "",password:""} } # 間違ったログイン情報をポストする
    assert_template 'sessions/new'  # フォームが正しくレンダリングされる
    assert_not flash.empty? # フラッシュメッセージが空じゃない
    get root_path # ルートに移動
    assert flash.empty? # フラッシュメッセージが空になっている
  end
  
end
