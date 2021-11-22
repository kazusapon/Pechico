class DashboardController < ApplicationController
  def index
    inquiries = Inquiry.without_deleted
    inquiries.load
    build_summary(inquiries)
    build_chart(inquiries)

    if inquiries = UnregisterInquiry.search(current_user)
      flash[:error] = "未登録の問合せが#{inquiries.size}件あります。"
    end
  end

  private

  def build_summary(inquiries)
    @total_count = inquiries.size
    @average_minutes = inquiries.average('end_time - start_time') / 60
    @max_minutes = inquiries.maximum('end_time - start_time') / 60

    system_count = inquiries.group(:system_id).count().max{|a, b| a <=> b}
    @maximum_system_name = System.find(system_count.first).name
  end

  def build_chart(inquiries)
    @inquiry_count = Dashboard::BuildChartService.build_inquiry_count(inquiries)
    
    @systems_line_chart = Dashboard::BuildChartService.build_inquiry_count_of_systems_line_chart(inquiries)
    @systems_pie_chart = Dashboard::BuildChartService.build_inquiry_count_of_systems_pie_chart(inquiries)

    @users_line_chart = Dashboard::BuildChartService.build_inquiry_count_of_users_line_chart(inquiries)
    @users_pie_chart = Dashboard::BuildChartService.build_inquiry_count_of_users_pie_chart(inquiries)

    @classifications_line_chart = Dashboard::BuildChartService.build_inquiry_count_of_classifications_line_chart(inquiries)
    @classifications_pie_chart = Dashboard::BuildChartService.build_inquiry_count_of_classifications_pie_chart(inquiries)

    @inquirier_kind_line_chart = Dashboard::BuildChartService.build_inquiry_count_of_inquirier_kinds_line_chart(inquiries)
    @inquirier_kind_pie_chart = Dashboard::BuildChartService.build_inquiry_count_of_inquirier_kinds_pie_chart(inquiries)
  end
end
