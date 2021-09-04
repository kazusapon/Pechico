module UsersHelper
  include ApplicationHelper

  def user_operate_button(user)
    str = ''
    if user.deleted?
      str += reborn_button(root_path)
      return str.html_safe
    end

    str += edit_button(edit_user_path(id: user.id), 'get', true)
    str += delete_button(user_path(id: user.id))
    return str.html_safe
  end
end