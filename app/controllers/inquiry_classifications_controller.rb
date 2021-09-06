class InquiryClassificationsController < ApplicationController
  PER = 10

  def index
    @inquiry_classifications = InquiryClassification.order(id: :asc).page(params[:page]).per(PER)
  end

  def new
    @modal_title = '問合せ分類登録'
    @inquiry_classification = InquiryClassification.new

    render 'save_modal'
  end

  def create
    @inquiry_classification = InquiryClassification.create!(inquiry_classification_params)
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{inquiry_classifications_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html
      format.js { render partial: 'inquiry_classiciations/error.js.erb' }
    end
  end

  def edit
    @modal_title = '問合せ分類編集'
    @inquiry_classification = InquiryClassification.find(params[:id])

    render 'save_modal'
  end

  def update
    @inquiry_classification = InquiryClassification.find(params[:id])
    @inquiry_classification.update!(inquiry_classification_params)
    respond_to do |format|
      format.html
      format.js { render js: "window.location.href = '#{inquiry_classifications_path}'" }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html
      format.js { render partial: 'inquiry_classiciations/error.js.erb' }
    end
  end

  def destroy
    inquiry_classification = InquiryClassification.find(params[:id])
    inquiry_classification.logical_delete
    
    redirect_to inquiry_classifications_path
  end

  def resurrect
    inquiry_classification = InquiryClassification.find(params[:id])
    inquiry_classification.resurrect

    redirect_to inquiry_classifications_path
  end

  private

  def inquiry_classification_params
    params.require(:inquiry_classification).permit(:name)
  end
end
