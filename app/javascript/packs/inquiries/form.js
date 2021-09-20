"use strict";

// 連携解除
$('#relation_cancel_btn').on('click', () => {
  $('#relation_text').val('');
  $('#inquiry_inquiry_relation_id').val('');
});

// 関連する問合せ検索
$('#inquiry_relation_search').on('click', () => {
  const params = {
    telephone_number: $('#inquiry_telephone_number').val(),
    sub_telephone_number: $('#inquiry_sub_telephone_number').val()
  }
  $.ajax(
    {
      type: 'GET',
      data: params,
      url: '/inquiries/related_inquiries',
      dataType: 'script'
    }
  );
});

