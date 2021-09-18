$(document).on("turbolinks:load", () => {

  // 連携解除
  $('#relation_cancel_btn').on('click', () => {
    $('#relation_text').val('');
    $('#inquiry_inquiry_relation_id').val('');
  });


})
