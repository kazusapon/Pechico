class InquiriesController < ApplicationController
  protect_from_forgery only: :unregister_create

  require 'csv'
  PER = 10
  UNREGISTER_PER = 9
  MOST_RECENT = 100
  
  def index
    set_select_box_items
    @q = Inquiry.ransack(params[:q])
    @inquiries = @q.result
                   .includes(:system)
                   .order(inquiry_date: :desc)
                   .order(start_time: :desc)
                   .page(params[:page])
                   .per(PER)
    if params[:export_csv]
      csv = generate_csv(@inquiries)
      send_data(csv, type: 'text/csv', filename: 'inquiries.csv')
    elsif params[:export_excel]
      render xlsx: 'index'
    end
  end

  def unregister_inquiries
    @inquiries = UnregisterInquiry.search(current_user)
                                  .page(params[:page])
                                  .per(UNREGISTER_PER)
                                  
    flash.now[:message] = '新着の問合せはありません。' if @inquiries.blank?
  end

  def show
    current_user
    @inquiry = Inquiry.find(params[:id])
  end

  def new
    set_select_box_items
    @inquiry = Inquiry.new
    @inquiry.inquiry_date = Date.today
    @inquiry.start_time = Time.zone.now.strftime('%H:%M')
    @inquiry.end_time = Time.zone.now.strftime('%H:%M')
  end

  def unregister_new
    set_select_box_items
    @unregister_inquiry = UnregisterInquiry.find(params[:id])
    @inquiry = Inquiry.new
    @inquiry.user_id = @unregister_inquiry.user_id
    @inquiry.inquiry_method_id = Inquiry.inquiry_method_ids[:telephone]
    @inquiry.inquiry_date = @unregister_inquiry.inquiry_date.try!(:strftime, '%Y-%m-%d')
    @inquiry.start_time = @unregister_inquiry.start_time.try!(:strftime, '%H:%M')
    @inquiry.end_time = @unregister_inquiry.end_time.try!(:strftime, '%H:%M')
    @inquiry.company_name = @unregister_inquiry.company_name
    @inquiry.inquirier_name = @unregister_inquiry.inquirier_name
    @inquiry.telephone_number = @unregister_inquiry.telephone_number
    @inquiry.inquirier_kind_id = @unregister_inquiry.inquirier_kind_id
    @inquiry.is_completed = @unregister_inquiry.is_completed

    render :new
  end

  def create
    @inquiry = Inquiry.new(inquiries_params)
    @inquiry.save!

    if params[:unregister_inquiry_id].present?
      unregister_inquiry = UnregisterInquiry.find(params[:unregister_inquiry_id])
      unregister_inquiry.destroy!
    end

    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid => e
    set_select_box_items
    
    render :new
  end

  def unregister_create
    unregister_inquiry = UnregisterInquiry.new(unregister_params)
    unregister_inquiry.save!

    render state: 200, json: {}
  rescue ActiveRecord::RecordInvalid => e
    render state: 500, json: {}
  end

  def edit
    set_select_box_items
    @inquiry = Inquiry.find(params[:id])
    @inquiry.start_time = @inquiry.start_time.strftime('%H:%M')
    @inquiry.end_time = @inquiry.end_time.strftime('%H:%M')
  end

  def unregister_edit
    if @unregister_inquiry = UnregisterInquiry.find_by(id: params[:id])
      set_select_box_items
      
      if @unregister_inquiry.user_id.blank?
        @unregister_inquiry.update!(user_id: current_user.id)

        ActionCable.server.broadcast("cti_channel", { is_modal_close: true })
      end

      @inquiries = Inquiry.includes(:system)
                          .includes(:user)
                          .includes(:inquiry_classification)
                          .where(telephone_number: @unregister_inquiry.telephone_number)
                          .order(inquiry_date: :desc)
                          .order(start_time: :desc)
                          .limit(5)

      @q = Inquiry.ransack(params[:q])

      render :unregister_edit and return
    end

    redirect_to action: :unregister_inquiries
  end

  def update
    @inquiry = Inquiry.find(params[:id])
    @inquiry.update!(inquiries_params)

    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid => e
    set_select_box_items
    
    render :edit
  end

  def unregister_update
    current_user
    if unregister_inquiry = UnregisterInquiry.find_by(id: params[:id], user_id: @current_user.id)
      is_completed = params[:completed].present?
      unregister_inquiry.update!(is_completed: is_completed, end_time: Time.now.strftime('%H:%M'))

      redirect_to unregister_new_inquiries_path(id: unregister_inquiry.id) and return
    end
    
    redirect_to action: :unregister_inquiries
  end

  def destroy
    inquiry = Inquiry.find(params[:id])
    inquiry.logical_delete

    redirect_to action: :index
  end

  def unregister_destroy
    unregister_inquiry = UnregisterInquiry.find(params[:id])
    unregister_inquiry.destroy!

    redirect_to action: :unregister_inquiries
  end

  def resurrect
    inquiry = Inquiry.find(params[:id])
    inquiry.resurrect

    redirect_to action: :index
  end

  def related_inquiries
    @inquiries = Inquiry.search_related_inquiries(params[:except_id], params[:telephone_number], params[:sub_telephone_number])
    render 'related_inquiries'
  end

  # unregister_editで利用
  def inquiry_search
    @q = Inquiry.ransack(params[:q])
    @inquiries = @q.result.select(:question, :answer)

    render json: @inquiries
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

  def approve
    inquiry = Inquiry.find(params[:id])
    inquiry.approve(current_user)

    redirect_to action: :index
  end

  def approve_cancel
    inquiry = Inquiry.find(params[:id])
    inquiry.approve_cancel

    redirect_to action: :index
  end

  private

  def search_params
    params.require(:q).permit!
  end

  def generate_csv(inquiries)
    csv_data = CSV.generate(force_quotes: true) do |csv|
      header = %w(No 着信日時 システム名 問合せ元 担当者 電話番号 電話番号（予備） 連絡方法 問合せ元種別 問合せ内容 回答者 回答内容 問合せ分類 完了状況)
      csv << header
      inquiries.order(id: :asc).each do |inquiry|
        row = []
        row << inquiry.id
        row << inquiry.inquiry_datetime_text
        row << inquiry.company_name
        row << inquiry.inquirier_name
        row << inquiry.telephone_number
        row << inquiry.sub_telephone_number
        row << Inquiry.inquiry_method_options.key(inquiry.inquiry_method_id)
        row << inquiry.inquirier_kind.name
        row << inquiry.question
        row << inquiry.user_name
        row << inquiry.answer
        row << inquiry.inquiry_classification.name
        row << Inquiry.complete_options.key(inquiry.is_completed)

        csv << row
      end
    end
  end

  def inquiries_params
    params.require(:inquiry).permit(
      :inquiry_date, :start_time, :end_time,
      :system_id, :user_id, :inquiry_classification_id, :inquiry_method_id,
      :company_name, :telephone_number, :sub_telephone_number, :inquirier_name, :inquirier_kind_id,
      :question, :answer, :parent_inquiry_id, :is_completed
    )
  end

  def unregister_params
    params.permit(
      :company_name, :telephone_number, :inquirier_name, :inquirier_kind_id,
      :inquiry_date, :start_time, :unknown_number_status
    )
  end

  def set_select_box_items
    @systems = System.without_deleted.pluck(:name, :id)
    @users = User.without_deleted.pluck(:name, :id)
    @inquiry_classifications = InquiryClassification.without_deleted.pluck(:name, :id)
    @inquirier_kinds = InquirierKind.without_deleted.pluck(:name, :id)
  end
end
