class CommonInquiriesController < ApplicationController
  PER = 10

  def index
    select_items
    @q = CommonInquiry.ransack(params[:q])
    @common_inquiries = @q.result.includes(:system).order(sort_order: :asc).page(params[:page]).per(PER)
  end

  def new
    select_items
    @common_inquiry = CommonInquiry.new
    render 'save_modal'
  end

  def create
    @common_inquiry = CommonInquiry.new(common_inquiry_params)
    @common_inquiry.save!
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{common_inquiries_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    select_items
    respond_to do |format|
      format.html
      format.js { render partial: 'shared/modal_errors.js.erb', locals: { model: @common_inquiry } }
    end
  end

  def edit
    select_items
    @common_inquiry = CommonInquiry.find(params[:id])
    render 'save_modal'
  end

  def update
    @common_inquiry = CommonInquiry.find(params[:id])
    @common_inquiry.update!(common_inquiry_params)
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{common_inquiries_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    select_items
    respond_to do |format|
      format.html
      format.js { render partial: 'shared/modal_errors.js.erb', locals: { model: @common_inquiry } }
    end
  end
  
  def destroy
    common_inquiry = CommonInquiry.find(params[:id])
    common_inquiry.destroy
    redirect_to action: 'index'
  end

  def search
    common_inquiries = CommonInquiry.search_at_system_id(params[:system_id])
    render json: common_inquiries.to_json
  end

  private

  def select_items
    @systems = System.without_deleted.pluck(:name, :id)
  end

  def common_inquiry_params
    params.require(:common_inquiry).permit(:system_id, :question, :answer, :sort_order)
  end
end
