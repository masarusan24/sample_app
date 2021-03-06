class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to user
    else
      # エラーメッセージを生成する
      flash.now[:danger] = 'invalid email/password combination' # 間違い
      render 'new'
    end
  end
  
  def destroy
  end
end
