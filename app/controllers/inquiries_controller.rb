class InquiriesController < ApplicationController
  PER = 10

  def index
    set_select_box_items
    @q = Inquiry.ransack(params[:q])
    @inquiries = @q.result.page(params[:page]).per(PER)
  end

  def show
  end

  def new
    set_select_box_items
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.create!(inquiries_params)

    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid => e
    set_select_box_items
    @inquiry ||= Inquiry.new
    
    render :new
  end

  def edit
  end

  def destroy
  end

  def related_inquiries
    @inquiries = Inquiry.search_related_inquiries(params[:telephone_number], params[:sub_telephone_number])
    render 'related_inquiries'
  end

  private

  def search_params
    params.require(:q).permit!
  end

  def inquiries_params
    params.require(:inquiry).permit(
      :inquiry_date, :start_time, :end_time,
      :system_id, :user_id, :inquiry_classification_id, :inquiry_method_id,
      :company_name, :telephone_number, :sub_telephone_number, :inquirier_name, :inquirier_kind_id,
      :question, :answer, :inquiry_relation_id, :is_completed
    )
  end

  def set_select_box_items
    @systems = System.without_deleted.pluck(:short_name, :id)
    @users = User.without_deleted.pluck(:name, :id)
    @inquiry_classifications = InquiryClassification.without_deleted.pluck(:name, :id)
    @inquirier_kinds = InquirierKind.without_deleted.pluck(:name, :id)
  end
end
