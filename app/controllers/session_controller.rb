class SessionController < ApplicationController
  skip_before_filter :check_sign_in, :only => [:create, :new, :destroy, :failure]

  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    session[:user_id] = auth_hash[:uid].to_i
    current_user
    if @current_user
      Rails.logger.info "Authenticated as #{@current_user.name}!"
      redirect_to '/'
    else
      Rails.logger.info "Not authorized."
      flash[:login] = "Your Calnet is not authorized to access OnDemand - please contact Information Security for access."
      redirect_to '/'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to 'https://auth.berkeley.edu/cas/logout'
  end

  def failure
    render :text => "SOMETHING BAD HAPPENED"
  end
end
