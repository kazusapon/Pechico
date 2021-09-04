module ApplicationHelper
  # 編集ボタンの生成
  def edit_button(url, method, is_ajax=false)
    btn = ''
    btn += link_to('編集', url, method: method.to_sym, remote: is_ajax, class: 'btn btn-secondary mr-2')
    
    return btn.html_safe
  end

  # 削除ボタンの生成
  def delete_button(url)
    btn = ''
    btn += link_to('削除', url, method: :delete, class: 'btn btn-danger mr-2')
    
    return btn.html_safe
  end

  # 削除取消（復活）ボタン
  def resurrect_button(url)
    btn = ''
    btn += link_to('削除取消', url, method: :get, class: 'btn btn-success mr-2')
    
    return btn.html_safe
  end
end