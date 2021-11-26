module Dashboard
  class BuildChartService
    # 表示形式
    DISPLAY_FORMAT = {
      '日次' => 0,
      '週次' => 1,
      '月次' => 2,
      '時間' => 3,
    }

    # 全件
    def self.build_inquiry_count(inquiries, display_format)
      return group_by_format(inquiries, display_format)
    end

    # System
    def self.build_inquiry_count_of_systems_line_chart(inquiries, display_format)
      data = System.order(:id).map{|system|
        {
          name: system.name,
          data: group_by_format(
                  inquiries.where(system_id: system.id),
                  display_format
                )
        }
      }
      
      return data
    end

    def self.build_inquiry_count_of_systems_pie_chart(inquiries)
      inquiries.joins(:system).group("systems.name").count
    end

    # User
    def self.build_inquiry_count_of_users_line_chart(inquiries, display_format)
      data = User.order(:id).map{|user|
        {
          name: user.name,
          data: group_by_format(
                  inquiries.where(user_id: user.id),
                  display_format
                )
        }
      }
      
      return data
    end

    def self.build_inquiry_count_of_users_pie_chart(inquiries)
      inquiries.joins(:user).group("users.name").count
    end

    # InquiryClassification
    def self.build_inquiry_count_of_classifications_line_chart(inquiries, display_format)
      data = InquiryClassification.order(:id).map{|classification|
        {
          name: classification.name,
          data: group_by_format(
                  inquiries.where(inquiry_classification_id: classification.id),
                  display_format
                )
        }
      }
      
      return data
    end

    def self.build_inquiry_count_of_classifications_pie_chart(inquiries)
      inquiries.joins(:inquiry_classification).group("inquiry_classifications.name").count
    end

    # InquirierKind
    def self.build_inquiry_count_of_inquirier_kinds_line_chart(inquiries, display_format)
      data = InquirierKind.order(:id).map{|kind|
        {
          name: kind.name,
          data: group_by_format(
                  inquiries.where(inquirier_kind_id: kind.id),
                  display_format
                )
        }
      }
      
      return data
    end

    def self.build_inquiry_count_of_inquirier_kinds_pie_chart(inquiries)
      inquiries.joins(:inquirier_kind).group("inquirier_kinds.name").count
    end

    def self.build_inquiry_speed_of_users_bar_chart(inquiries)
      inquiries.joins(:user).group("users.name").average('(inquiries.end_time - inquiries.start_time) / 60')
    end

    def self.build_inquiry_speed_of_systems_bar_chart(inquiries)
      inquiries.joins(:system).group("systems.name").average('(inquiries.end_time - inquiries.start_time) / 60')
    end

    private

    def self.group_by_format(inquiries, format=DISPLAY_FORMAT['日次'])
      case format.to_i
      when DISPLAY_FORMAT['日次']
        return inquiries.group_by_day(:inquiry_date, format: "%_m-%e").count
      when DISPLAY_FORMAT['週次']
        return inquiries.group_by_week(:inquiry_date, format: "%a").count
      when DISPLAY_FORMAT['月次']
        return inquiries.group_by_month(:inquiry_date, format: "%_m").count
      when DISPLAY_FORMAT['時間']
        return inquiries.group_by_hour(:inquiry_date, format: "%k").count
      end
    end
  end
end