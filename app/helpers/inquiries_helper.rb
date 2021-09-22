module InquiriesHelper
  def build_inquiry_related_text(inquiry)
    str = ''
    str += inquiry.inquiry_datetime_text
    str += ' '
    str += inquiry.company_name
    return str
  end
end
