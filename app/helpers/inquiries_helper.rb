module InquiriesHelper
  def build_inquiry_related_text(inquiry)
    str = ''
    str += inquiry.inquiry_datetime_text
    str += ' '
    str += inquiry.company_name
    return str
  end

  def inquiry_operate_button(inquiry)
    str = ''
    if inquiry.deleted?
      str += resurrect_button(resurrect_inquiry_path(inquiry))
      return str.html_safe
    end
    str += edit_button(edit_inquiry_path(inquiry.id), 'get', true)
    str += delete_button(inquiry_path(inquiry.id))
    
    return str.html_safe
  end
end
