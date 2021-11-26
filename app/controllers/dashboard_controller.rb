class DashboardController < ApplicationController
  def index
    search_items
    @q = Inquiry.without_deleted.ransack(params[:q])
    inquiries = @q.result                   
    build_summary(inquiries)
    build_chart(inquiries)

    if unregister_inquiries = UnregisterInquiry.search(current_user)
      flash[:error] = "未登録の問合せが#{unregister_inquiries.size}件あります。"
    end
  end

  private

  def search_items
    @systems = System.order(:id).select(:id, :name)
    @users = User.order(:id).select(:id, :name)

    @display_format = Dashboard::BuildChartService::DISPLAY_FORMAT
  end

  def build_summary(inquiries)
    @total_count = inquiries.size

    @average_minutes = 0
    @max_minutes = 0
    @maximum_system_name = ''
    if inquiries.present?
      @average_minutes = inquiries.average('end_time - start_time') / 60
      @max_minutes = inquiries.maximum('end_time - start_time') / 60

      system_count = inquiries.group(:system_id).count().max{|a, b| a <=> b}
      @maximum_system_name = System.find(system_count.first).name
    end
  end

  def build_chart(inquiries)
    @inquiry_count = Dashboard::BuildChartService.build_inquiry_count(inquiries, params[:display_format])
    
    @systems_line_chart = Dashboard::BuildChartService.build_inquiry_count_of_systems_line_chart(inquiries, params[:display_format])
    @systems_pie_chart = Dashboard::BuildChartService.build_inquiry_count_of_systems_pie_chart(inquiries)

    @users_line_chart = Dashboard::BuildChartService.build_inquiry_count_of_users_line_chart(inquiries, params[:display_format])
    @users_pie_chart = Dashboard::BuildChartService.build_inquiry_count_of_users_pie_chart(inquiries)

    @classifications_line_chart = Dashboard::BuildChartService.build_inquiry_count_of_classifications_line_chart(inquiries, params[:display_format])
    @classifications_pie_chart = Dashboard::BuildChartService.build_inquiry_count_of_classifications_pie_chart(inquiries)

    @inquirier_kind_line_chart = Dashboard::BuildChartService.build_inquiry_count_of_inquirier_kinds_line_chart(inquiries, params[:display_format])
    @inquirier_kind_pie_chart = Dashboard::BuildChartService.build_inquiry_count_of_inquirier_kinds_pie_chart(inquiries)

    @users_speed_bar_chart = Dashboard::BuildChartService.build_inquiry_speed_of_users_bar_chart(inquiries)
    @systems_speed_bar_chart = Dashboard::BuildChartService.build_inquiry_speed_of_systems_bar_chart(inquiries)
  end
end
