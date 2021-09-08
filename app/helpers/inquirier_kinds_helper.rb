module InquirierKindsHelper
  include ApplicationHelper

  def inquirier_kind_operate_button(kind)
    str = ''
    if kind.deleted?
      str += resurrect_button(resurrect_inquirier_kinds_path(id: kind.id))
      return str.html_safe
    end
    str += edit_button(edit_inquirier_kind_path(kind.id), 'get', true)
    str += delete_button(inquirier_kind_path(kind.id))
    
    return str.html_safe
  end
end
