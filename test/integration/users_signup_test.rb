require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # 登録失敗用のテスト
  test "invalid signup information" do
    # getメソッドを使ってユーザー登録ページにアクセス
    get signup_path

    # assert_no_differenceのブロック(postメソッド)を実行する前後で
    # 引数の値 (User.count) が変わらないことをテストする
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",  # Rails5.0からparamsハッシュを明示的に含めることが推奨されている
                        email: "user@invalid",
                        password: "foo",
                        password_confirmation: "bar" }
                      }
    end

    # 送信に失敗してnewアクションが再描画されることをテスト
    assert_template 'users/new'

    # エラーメッセージのテスト
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'

    # POST送信先が正しいかどうかのテスト
    assert_select 'form[action="/signup"]'
  end
end
