module UsersHelper
  include ApplicationHelper

  def user_operate_button(user)
    str = ''
    if user.deleted?
      str += resurrect_button(resurrect_users_path(id: user.id))
      return str.html_safe
    end
    str += edit_button(edit_user_path(id: user.id), 'get', true)
    unless log_in?(user)
      str += delete_button(user_path(id: user.id))
    end
    
    return str.html_safe
  end
end
