class ScanController < ApplicationController
  def index
    @scans = policy_scope(Scan)
  end

  def new
    @scan = Scan.new
  end

  def create
    s_params = scan_params # Strong params

    begin
      s_params[:time] = DateTime.strptime(s_params[:time], '%d %B %Y - %H:%M')
    rescue
      s_params[:time] = "" # If a ill-formatted time is given - XSS attempt, most likely
    end
    s_params[:user] = @current_user.calnet

    @scan = Scan.new s_params
    Rails.logger.debug "Attempting to create new scan..."
    Rails.logger.debug @scan.inspect
    if @scan.save
      Rails.logger.warn "Scan ##{@scan.id} created!"
      flash[:success] = "<b>Scan successfully created!</b> Check your user page for more information!"
      redirect_to @scan
    else
      Rails.logger.debug "Creation failed!"
      Rails.logger.debug @scan.errors.full_messages
      flash[:error] = "<b>Oops!</b> There were some problems with your scan:"
      render :action => 'new'
    end
  end

  def show
    @scan = Scan.find params[:id]
    authorize @scan
  end

  def edit
    @scan = Scan.find params[:id]
    authorize @scan
  end

  def update
    @scan = Scan.find params[:id]
    authorize @scan
    Rails.logger.debug "Attempting to update Scan ##{@scan.id}..."
    Rails.logger.debug @scan.inspect
    if @scan.update_attributes params[:scan]
      Rails.logger.warn "Scan ##{@scan.id} updated!"
      Rails.logger.debug @scan.inspect
      redirect_to scan_path
    else
      Rails.logger.debug "Updating failed!"
      Rails.logger.debug @scan.errors
      render :action => :edit
    end
  end

  def destroy
    @scan = Scan.find params[:id]
    authorize @scan
    @scan.destroy
    Rails.logger.warn "Scan ##{@scan.id} destroyed!"
    redirect_to scans_path
  end

  private
    def scan_params
      params.require(:scan).permit(:targets, :time)
    end
end
