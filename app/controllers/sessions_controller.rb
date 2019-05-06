class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated? #有効なユーザであればログインできる
        log_in @user #sessions_helper.rb
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user #sessions_helper.rb アクセスしようとしたURLが記録されていればそちらへ、なければuserへ
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? #sessions_helper.rb
    redirect_to root_url
  end

end
