require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:masato)
  end
  
  # 間違った情報で編集した時のテスト
  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                            email: "foo@invalid",
                            password: "foo",
                            password_confirmation: "bar" }}
  
    assert_template 'users/edit'                          
  end
end
