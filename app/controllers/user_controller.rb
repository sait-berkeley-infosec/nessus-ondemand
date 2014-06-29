class UserController < ApplicationController
  def index
    authorize @current_user
    @users = User.all
  end

  def show
    authorize @current_user
    @user = User.find(params[:id])
  end

  def become
    authorize @current_user
    session[:user_id] = params[:id].to_i
    redirect_to root_path
  end
end
