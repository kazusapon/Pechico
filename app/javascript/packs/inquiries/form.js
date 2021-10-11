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

  const result = await searchInquiries(url, params);
  buildInquiriesRow(result);

  $('#modal_system_select').val(system_id);
});

// よくある作業モーダル検索ボタンクリック
$('#inquiry_search_btn').on('click', async () => {
  const system_id = $('#modal_system_select').val();
  const url = '/common_inquiries/search';
  const params = {system_id: system_id};

  const result = await searchInquiries(url, params);
  buildInquiriesRow(result);
});

function searchInquiries(url, params) {
  return $.ajax(
    {
      type: 'GET',
      data: params,
      url: url,
      dataType: 'json'
    }
  );
}

function buildInquiriesRow(inquiry) {
  removeSearchInquiriesRow();

  $.each(inquiry, (i, data) => {
    let row = '<tr>';
    row += `  <td class="question">${data.question}</td>`;
    row += `  <td class="answer">${data.answer}</td>`;
    row += '  <td><input type="button" value="選択" class="btn btn-info"></td>';
    row += '</tr>';

    $('#searched_inquiries').append(row);
    commonInuqirySelectButtonEventListner();
  });

  $('#search_inquiry_modal').modal('show');
}

// よくある問合せの選択ボタンのイベントリスナー
function commonInuqirySelectButtonEventListner() {
  const lastRow = $('#searched_inquiries').children('tr').last();
  $(lastRow.find('input[type=button]')).on('click', (event) => {
    const selectedRow = event.currentTarget.closest('tr');
    const question = $(selectedRow).find('.question').text();
    const answer = $(selectedRow).find('.answer').text();
    
    $('#inquiry_question').val(question);
    $('#inquiry_answer').val(answer);
    $('#search_inquiry_modal').modal('hide');
  });
}

function removeSearchInquiriesRow() {
  $('#searched_inquiries').children('tr').remove();
}