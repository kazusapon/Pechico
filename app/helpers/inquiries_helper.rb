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
    str = detail_button(inquiry_path(inquiry), 'get', true)
    if inquiry.deleted?
      str += resurrect_button(resurrect_inquiry_path(inquiry))
      return str.html_safe
    end
    str += edit_button(edit_inquiry_path(inquiry.id), 'get', false, edit_inquiry_path(inquiry))
    str += delete_button(inquiry_path(inquiry.id))
    
    return str.html_safe
  end

  def inquiry_show_operate_button(inquiry, user)
    str = ''
    if inquiry.deleted?
      str += resurrect_button(resurrect_inquiry_path(inquiry))
      return str.html_safe
    end
    str += edit_button(edit_inquiry_path(inquiry.id), 'get', false, edit_inquiry_path(inquiry))
    
    if user != inquiry.user
      if inquiry.approver.blank?
        str += approve_button(approve_inquiry_path(inquiry))
      else
        str += approve_cancel_button(approve_cancel_inquiry_path(inquiry))
      end
    end

    return str.html_safe
  end

  def inquiry_datetime(inquiry)
    return inquiry.inquiry_date.strftime('%Y-%m-%d') + ' ' + inquiry.start_time.strftime('%H:%M') + ' ～ ' + inquiry.end_time.strftime('%H:%M')
  end
end
