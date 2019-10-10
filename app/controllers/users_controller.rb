class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.notfound"
    redirect_to root_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "users.create.welcome"
      redirect_to @user
    else
      flash[:danger] = t "users.create.fail"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end
end
