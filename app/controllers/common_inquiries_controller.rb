class CommonInquiriesController < ApplicationController
  PER = 10

  def index
    search_items
    @q = CommonInquiry.ransack(params[:q])
    @common_inquiries = @q.result.order(sort_order: :asc).page(params[:page]).per(PER)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end
  
  def destroy
  end

  private

  def search_items
    @systems = System.without_deleted
  end
end
