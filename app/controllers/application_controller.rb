class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  include SessionsHelper


  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in? # 未ログインなのでログイン画面へ
        store_location   # sessions_helper.rb アクセスしようとした画面を記録
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end



end
