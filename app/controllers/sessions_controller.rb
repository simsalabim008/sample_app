class SessionsController < ApplicationController
  def new
  end

  def create
    _user = User.find_by(email: params[:session][:email].downcase)
    if _user && _user.authenticate(params[:session][:password])
      reset_session
      log_in _user
      params[:session][:remember_me] == '1' ? remember(_user) : forget(_user)
      session[:session_token] = _user.session_token
      redirect_to _user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
