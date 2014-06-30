class UserController < ApplicationController
  def index
    authorize @current_user
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    authorize @user
    @scans = Scan.where(:user => @user.calnet)
  end

  def become
    authorize @current_user
    session[:user_id] = params[:id].to_i
    redirect_to root_path
  end
end
