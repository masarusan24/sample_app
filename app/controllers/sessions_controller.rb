class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザログイン後にユーザ情報のページにリダイレクトする
    else
      # エラーメッセージを生成する
      render 'new'
    end
  end
  
  def destroy
  end
end
