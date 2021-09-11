class InquiriesController < ApplicationController
  def index
    set_search_items
    @q = Inquiry.ransack(params[:q])
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def destroy
  end

  private

  def inquiries_params
  end

  def set_search_items
    @systems = System.without_deleted.pluck(:short_name, :id)
    @users = User.without_deleted.pluck(:name, :id)
    @inquiry_classifications = InquiryClassification.without_deleted.pluck(:name, :id)
    @inquirier_kinds = InquirierKind.without_deleted.pluck(:name, :id)
  end
end
