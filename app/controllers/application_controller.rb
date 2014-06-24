class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_sign_in

  def check_sign_in
    unless user_signed_in?
      redirect_to portal_path
    end
  end

  private
  def user_signed_in?
    return true if !User.find_by_calnet(session[:user_id]).nil?
  end
end
