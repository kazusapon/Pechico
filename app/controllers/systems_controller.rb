class SystemsController < ApplicationController
  PER = 10

  def index
    @systems = System.order(id: :asc).page(params[:page]).per(PER)
  end

  def new
    @modal_title = "システム登録"
    @system = System.new

    render 'save_modal'
  end

  def create
    @system = System.new(app_params)
    @system.save!
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{systems_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html
      format.js { render partial: 'systems/error.js.erb' }
    end
  end

  def edit
    @modal_title = "システム編集"
  end

  def update
  end

  def destroy
  end

  private

  def app_params
    params.require(:system).permit(:name, :short_name)
  end
end
