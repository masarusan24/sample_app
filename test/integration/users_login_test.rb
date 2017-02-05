require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
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
