module SessionsHelper
  
  # 渡されたユーザでログインする
  def log_in (user)
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザを返す（いる場合）
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  # ログインしていればtrue,そうでなければfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  # ログアウトする
  def log_out (user)
    session.delete(:user_id)
    @current_user = nil
  end
end
