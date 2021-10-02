module CommonInquiriesHelper
  include ApplicationHelper

  def common_inquiry_operate_button(common_inquiry)
    str = ""
    str += edit_button(edit_common_inquiry_path(common_inquiry.id), 'get', true)
    str += delete_button(common_inquiry_path(common_inquiry.id))
    
    return str.html_safe
  end
end
