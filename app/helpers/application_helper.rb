module ApplicationHelper
  # 戻るボタン
  def back_button_tag(url)
    btn = ''
    btn += link_to('戻る', url, class: 'btn btn-default')

    return btn.html_safe
  end

  # 保存ボタン
  def save_button_tag(form)
    btn = ''
    btn += form.submit('保存', class: 'btn btn-primary')

    return btn.html_safe
  end

  # 詳細ボタンの生成
  def detail_button(url, method, is_ajax=false)
    btn = ''
    btn += link_to('詳細', url, method: :get, remote: is_ajax, class: 'btn btn-info mr-2')
    
    return btn.html_safe
  end

  # 新着情報の登録ボタンの生成
  def entry_button(url, method, is_ajax=false, use_turbolinks=true)
    btn = ''
    btn += link_to('登録', url, method: method.to_sym, remote: is_ajax, class: 'btn btn-primary mr-2', data: {turbolinks: use_turbolinks})
    
    return btn.html_safe
  end

  # 新規登録ボタンの作成
  def new_button(url, method, is_ajax=false, use_turbolinks=true)
    btn = ''
    btn += link_to('新規登録', url, method: method.to_sym, remote: is_ajax, class: 'btn btn-primary mr-2', data: {turbolinks: use_turbolinks})
    
    return btn.html_safe
  end

  # 編集ボタンの生成
  def edit_button(url, method, is_ajax=false, use_turbolinks=true)
    btn = ''
    btn += link_to('編集', url, method: method.to_sym, remote: is_ajax, class: 'btn btn-secondary mr-2', data: {turbolinks: use_turbolinks})
    
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

  # 承認ボタン
  def approve_button(url)
    btn = ''
    btn += link_to('承認', url, method: :get, class: 'btn btn-primary mr-2')
    
    return btn.html_safe
  end

  # 承認取消ボタン
  def approve_cancel_button(url)
    btn = ''
    btn += link_to('承認取消', url, method: :get, class: 'btn btn-danger mr-2')
    
    return btn.html_safe
  end

  # 行番号を求める
  def calc_row_number(enumerable_model, i)
    enumerable_model.try(:offset_value).to_i + i + 1
  end
end