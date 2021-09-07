module InquiryClassificationsHelper
  include ApplicationHelper

  def inquiry_classification_operate_button(classification)
    str = ''
    if classification.deleted?
      str += resurrect_button(resurrect_inquiry_classifications_path(id: classification.id))
      return str.html_safe
    end
    str += edit_button(edit_inquiry_classification_path(classification.id), 'get', true)
    str += delete_button(inquiry_classification_path(classification.id))
    
    return str.html_safe
  end
end
