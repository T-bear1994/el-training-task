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
      render :new_admin
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def admin?
    if current_user.admin == false, flash: {notice: "管理者以外はアクセスできません" }
      redirect_to tasks_path
    end
  end
end
