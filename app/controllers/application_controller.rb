class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception
  before_filter :check_sign_in

  def current_user
    @current_user ||= User.find_by_calnet(session[:user_id])
  end

  def check_sign_in
    current_user
    unless @current_user
      redirect_to portal_path
    end
  end
end
