class InquirierKindsController < ApplicationController
  PER = 10

  def index
    @inquirier_kinds = InquirierKind.order(id: :asc).page(params[:page]).per(PER)
  end

  def new
    @inquirier_kind = InquirierKind.new
    render 'save_modal'
  end

  def create
    @inquirier_kind = InquirierKind.new(inquirier_kind_params)
    @inquirier_kind.save!
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{inquirier_kinds_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html
      format.js { render partial: 'shared/modal_errors.js.erb', locals: { model: @inquirier_kind } }
    end
  end

  def edit
    @inquirier_kind = InquirierKind.find(params[:id])
    render 'save_modal'
  end

  def update
    @inquirier_kind = InquirierKind.find(params[:id])
    @inquirier_kind = @inquirier_kind.update!(inquirier_kind_params)
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{inquirier_kinds_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html
      format.js { render partial: 'shared/modal_errors.js.erb', locals: { model: @inquirier_kind } }
    end
  end

  def destroy
    inquirier_kind = InquirierKind.find(params[:id])
    inquirier_kind.logical_delete
    redirect_to action: :index
  end

  def resurrect
    inquirier_kind = InquirierKind.find(params[:id])
    inquirier_kind.resurrect

    redirect_to action: :index
  end


  private

  def inquirier_kind_params
    params.require(:inquirier_kind).permit(:name)
  end
end
