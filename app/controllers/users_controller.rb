class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.admin = false
    if @user.save
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
    
  end

  def edit

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
