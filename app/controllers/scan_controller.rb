class ScanController < ApplicationController
  def index
    @scans = Scan.all
  end

  def new
    @scan = Scan.new
  end

  def create
    @scan = Scan.new params[:scan]
    # TODO: Create tagged logging for the user
    Rails.logger.debug "Attempting to create new scan..."
    Rails.logger.debug @scan.inspect
    if @scan.save
      Rails.logger.warn "Scan ##{@scan.id} created!"
      redirect_to new_scan_path
    else
      Rails.logger.debug "Creation failed!"
      Rails.logger.debug @scan.errors
      render :action => 'new'
    end
  end

  def show
    @scan = Scan.find params[:id]
  end

  def edit
    @scan = Scan.find params[:id]
  end

  def update
    @scan = Scan.find params[:id]
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
    @scan.destroy
    Rails.logger.warn "Scan ##{@scan.id} destroyed!"
    redirect_to scans_path
  end
end
