module SessionsHelper
  
  # 渡されたユーザでログインする
  def log_in (user)
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザを返す（いる場合）
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
