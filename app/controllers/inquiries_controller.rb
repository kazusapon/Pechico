class InquiriesController < ApplicationController
  PER = 10
  MOST_RECENT = 100
  
  def index
    set_select_box_items
    @q = Inquiry.ransack(params[:q])
    @inquiries = @q.result
                   .includes(:system)
                   .includes(:user)
                   .includes(:inquirier_kind)
                   .includes(:inquiry_classification)
                   .order(inquiry_date: :desc)
                   .order(start_time: :desc)
                   .page(params[:page])
                   .per(PER)
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end

  def new
    set_select_box_items
    @inquiry = Inquiry.new
    @inquiry.inquiry_date = Date.today
    @inquiry.start_time = Time.zone.now.strftime('%H:%M')
    @inquiry.end_time = Time.zone.now.strftime('%H:%M')
  end

  def create
    @inquiry = Inquiry.new(inquiries_params)
    @inquiry.save!

    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid => e
    set_select_box_items
    
    render :new
  end

  def edit
    set_select_box_items
    @inquiry = Inquiry.find(params[:id])
    @inquiry.start_time = @inquiry.start_time.strftime('%H:%M')
    @inquiry.end_time = @inquiry.end_time.strftime('%H:%M')
  end

  def update
    @inquiry = Inquiry.find(params[:id])
    @inquiry.update!(inquiries_params)

    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid => e
    set_select_box_items
    
    render :edit
  end

  def destroy
    inquiry = Inquiry.find(params[:id])
    inquiry.logical_delete
    redirect_to action: 'index'
  end

  def resurrect
    inquiry = Inquiry.find(params[:id])
    inquiry.resurrect
    redirect_to action: 'index'
  end

  def related_inquiries
    @inquiries = Inquiry.search_related_inquiries(params[:except_id], params[:telephone_number], params[:sub_telephone_number])
    render 'related_inquiries'
  end

  def qa_search
    if params[:question].blank? && params[:answer].blank?
      render json: [].to_json
      return 
    end
    inquiries = Inquiry.without_deleted
                       .where(system_id: params[:system_id])
                       .where('question LIKE ?', "%#{params[:question]}%")
                       .where('answer LIKE ?', "%#{params[:answer]}%")
                       .order(inquiry_date: :desc)
                       .order(start_time: :desc)
    render json: inquiries.to_json
  end

  def most_recent_search
    inquiries = Inquiry.without_deleted
                       .where(system_id: params[:system_id])
                       .order(inquiry_date: :desc)
                       .order(start_time: :desc)
                       .limit(MOST_RECENT)
    render json: inquiries.to_json
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
      :question, :answer, :parent_inquiry_id, :is_completed
    )
  end

  def set_select_box_items
    @systems = System.without_deleted.pluck(:name, :id)
    @users = User.without_deleted.pluck(:name, :id)
    @inquiry_classifications = InquiryClassification.without_deleted.pluck(:name, :id)
    @inquirier_kinds = InquirierKind.without_deleted.pluck(:name, :id)
  end
end
