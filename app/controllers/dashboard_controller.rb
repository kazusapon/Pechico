class DashboardController < ApplicationController
  def index
    inquiries = Inquiry.without_deleted
    build_summary(inquiries)
  end

  private

  def build_summary(inquiries)
    @total_count = inquiries.size
    @average_minutes = inquiries.average('end_time - start_time') / 60
    @max_minutes = inquiries.maximum('end_time - start_time') / 60

    system_count = inquiries.group(:system_id).count().max{|a, b| a <=> b}
    @maximum_system_name = System.find(system_count.first).name
  end
end
