import consumer from "./consumer"

consumer.subscriptions.create("CtiChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const modal_html = this._buildCtiModal(data);
    $('#cti-modal-area').append(modal_html);
    $('#cti-modal-open-button').trigger("click");
  },

  _buildCtiModal(data) {
    const html = `
      <button type="button" id="cti-modal-open-button" style="display: none;" data-bs-toggle="modal" data-bs-target="#cti-modal">ctiModalOPEN</button>
      <div class="modal fade" id="cti-modal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-modal="true" role="dialog">
        <div class="modal-dialog modal-lg">
          <div class="modal-content bg-danger">
            <div class="modal-header">
              <h4 class="modal-title">着信があります</h4>
            </div>
            <div class="modal-body">
              <ul class="list-group list-group-flush">
                <li class="list-group-item list-group-item-danger">
                  <i class="fas fa-clock mr-3"></i> ${data.datetime}
                </li>
                <li class="list-group-item list-group-item-danger">
                  <i class="fas fa-industry mr-3"></i> ${data.company_name}
                </li>
                <li class="list-group-item list-group-item-danger">
                  <i class="fas fa-user-tie mr-3"></i> ${data.inquirier_name}
                </li>
                <li class="list-group-item list-group-item-danger">
                  <i class="fas fa-phone mr-3"></i> ${data.telephone_number}
                </li>
                <li class="list-group-item list-group-item-danger">
                  <i class="fas fa-user-friends"></i> ${data.inquirier_kind}
                </li>
              </ul>
            </div>
            <div class="modal-footer justify-content-between">
              <button type="button" class="btn btn-lg btn-outline-light" data-bs-dismiss="modal">キャンセル</button>
              <button type="button" class="btn btn-lg btn-outline-light">担当する</button>
            </div>
          </div>
        </div>
      </div>
    `;

    return html;
  }
});
