class Admin::UsersController < ApplicationController
  include SessionsHelper
  skip_before_action :logout_required
  before_action :admin?

  def new
    @user = User.new
  end

  def index
    @users = User.all.page(params[:page]).per(10)
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'アカウントを登録しました'
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    user = User.find(params[:id])
  end

  def update
    user = @user 
    if @user.update(user_params)
      redirect_to user_path(params[:id])
    else
      render :new
    end
  end

  def destroy
    user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def admin?
    if current_user.admin == false
      redirect_to tasks_path, flash: {notice: "管理者以外はアクセスできません" }
    end
  end
end
