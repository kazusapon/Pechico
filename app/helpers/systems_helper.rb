module SystemsHelper
  include ApplicationHelper

  def system_operate_button(sys)
    str = ''
    if sys.deleted?
      str += resurrect_button(resurrect_systems_path(id: sys.id))
      return str.html_safe
    end
    str += edit_button(edit_system_path(id: sys.id), 'get', true)
    str += delete_button(system_path(id: sys.id))
    
    return str.html_safe
  end
end
