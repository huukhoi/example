class SessionsController < ApplicationController
  before_action :load_params, only: :create

  def new; end

  def create
    if @user.authenticate @sessions[:password]
      if @user.activated?
        log_in @user
        session[:remember_me] == Settings.one ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        flash[:warning] = t "sessions.not-check"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def load_params
    @sessions = params[:session]
    @user = User.find_by email: @sessions[:email].downcase
    return if @user

    flash.now[:danger] = t ".invalid"
    render :new
  end

  def login_with_user_activated
    log_in @user
    @sessions[:remember_me] == Settings.TRUE ? remember(@user) : forget(@user)
    redirect_back_or @user
  end

  def warn_user_not_activate
    flash[:warning] = t ".account_not_activate_message"
    redirect_to root_url
  end
end
