class Inquiry < ApplicationRecord
  enum is_completeds: { incomplete: false, complete: true }
  enum inquiry_method_ids: { telephone: 1, mail: 2, direct: 3, other: 4 }

  def self.complete_options
    return { '未完了' => is_completeds[:incomplete], '完了' => is_completeds[:complete], }
  end

  def self.inquiry_method_options
    return {
      '電話' => inquiry_method_ids[:telephone],
      'メール' => inquiry_method_ids[:mail],
      '直接' => inquiry_method_ids[:direct],
      'その他' => inquiry_method_ids[:other],
    }
  end
end
