class SessionController < ApplicationController
  skip_before_filter :check_sign_in, :only => [:create, :new]

  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    @user = User.find_by_calnet(auth_hash[:uid].to_i)
    if @user
      Rails.logger.info "Authenticated as #{@user.name}!"
      session[:user_id] = @user.calnet
      redirect_to '/'
    else
      Rails.logger.info "Not authorized."
      flash[:error] = "Your Calnet is not authorized to access OnDemand - please contact Information Security for access."
      redirect_to '/'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end

  def failure
    render :text => "SOMETHING BAD HAPPENED"
  end
end
