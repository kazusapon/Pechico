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

// よくある作業検索
$('#common_inquiry_search').on('click', async () => {
  const system_id = $('#inquiry_system_id').val();
  const url = '/common_inquiries/search';
  const params = {system_id: system_id};

  // _search_inquiry_modal.html.erbのJSメソッド実行
  const result = await searchInquiries(url, params);
  buildInquiriesRow(result);

  $('#modal_system_select').val(system_id);
});