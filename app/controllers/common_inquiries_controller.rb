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
      format.js { render partial: 'common_inquiries/error.js.erb' }
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
      format.js { render partial: 'common_inquiries/error.js.erb' }
    end
  end
  
  def destroy
    common_inquiry = CommonInquiry.find(params[:id])
    common_inquiry.destroy
    redirect_to action: 'index'
  end

  private

  def select_items
    @systems = System.without_deleted.pluck(:short_name, :id)
  end

  def common_inquiry_params
    params.require(:common_inquiry).permit(:system_id, :question, :answer, :sort_order)
  end
end
