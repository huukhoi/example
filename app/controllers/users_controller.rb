class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.n25
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.create.welcome"
      redirect_to @user
    else
      flash.now[:warning] = t "users.create.fail"
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t "users.update.profile"
      redirect_to @user
    else
      flash[:danger] = t "users.update.error"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.index.delete_success"
    else
      flash[:danger] = t "users.index.delete_error"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.notfound"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "users.edit.login_request"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
