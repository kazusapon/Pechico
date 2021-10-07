class SystemsController < ApplicationController
  PER = 10

  def index
    @systems = System.order(id: :asc).page(params[:page]).per(PER)
  end

  def new
    @system = System.new
    render 'save_modal'
  end

  def create
    @system = System.new(system_params)
    @system.save!
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{systems_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html
      format.js { render partial: 'shared/modal_errors.js.erb', locals: { model: @system } }
    end
  end

  def edit
    @system = System.find(params[:id])
    render 'save_modal'
  end

  def update
    @system = System.find(params[:id])
    @system.update!(system_params)
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{systems_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html
      format.js { render partial: 'shared/modal_errors.js.erb', locals: { model: @system } }
    end
  end

  def destroy
    sys = System.find(params[:id])
    sys.logical_delete

    redirect_to systems_path
  end

  def resurrect
    sys = System.find(params[:id])
    sys.resurrect

    redirect_to systems_path
  end

  private

  def system_params
    params.require(:system).permit(:name, :short_name)
  end
end
