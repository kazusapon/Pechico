module Dashboard
  class BuildChartService
    # 全件
    def self.build_inquiry_count(inquiries)
      return inquiries.group_by_day(:inquiry_date).count
    end

    # System
    def self.build_inquiry_count_of_systems_line_chart(inquiries)
      data = System.order(:id).map{|system|
        {
          name: system.name,
          data: inquiries.where(system_id: system.id)
                         .group_by_day(:inquiry_date)
                         .count
        }
      }
      
      return data
    end

    def self.build_inquiry_count_of_systems_pie_chart(inquiries)
      inquiries.joins(:system).group("systems.name").count
    end

    # User
    def self.build_inquiry_count_of_users_line_chart(inquiries)
      data = User.order(:id).map{|user|
        {
          name: user.name,
          data: inquiries.where(user_id: user.id)
                         .group_by_day(:inquiry_date)
                         .count
        }
      }
      
      return data
    end

    def self.build_inquiry_count_of_users_pie_chart(inquiries)
      inquiries.joins(:user).group("users.name").count
    end

    # InquiryClassification
    def self.build_inquiry_count_of_classifications_line_chart(inquiries)
      data = InquiryClassification.order(:id).map{|classification|
        {
          name: classification.name,
          data: inquiries.where(inquiry_classification_id: classification.id)
                         .group_by_day(:inquiry_date)
                         .count
        }
      }
      
      return data
    end

    def self.build_inquiry_count_of_classifications_pie_chart(inquiries)
      inquiries.joins(:inquiry_classification).group("inquiry_classifications.name").count
    end

    # InquirierKind
    def self.build_inquiry_count_of_inquirier_kinds_line_chart(inquiries)
      data = InquirierKind.order(:id).map{|kind|
        {
          name: kind.name,
          data: inquiries.where(inquirier_kind_id: kind.id)
                         .group_by_day(:inquiry_date)
                         .count
        }
      }
      
      return data
    end

    def self.build_inquiry_count_of_inquirier_kinds_pie_chart(inquiries)
      inquiries.joins(:inquirier_kind).group("inquirier_kinds.name").count
    end
  end
end