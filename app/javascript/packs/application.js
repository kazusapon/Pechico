// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

var jQuery = require('jquery')
global.$ = global.jQuery = jQuery
window.$ = window.jQuery = jQuery

require('flatpickr');
const japan = require("flatpickr/dist/l10n/ja.js").default.ja;
$(document).on("turbolinks:load", () => {
  const date_config = {
    locale: japan
  }
  $(".datepickr").flatpickr(date_config);
  
  const time_config = {
    enableTime: true,
    noCalendar: true,
    enableSeconds: false,
    dateFormat: "H:i",
    time_24hr: true
  }
  $(".timepickr").flatpickr(time_config);
});

require("../stylesheets/application.scss");
require("admin-lte");
require('bootstrap');

import "@fortawesome/fontawesome-free/js/all";
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"


Rails.start()
Turbolinks.start()
ActiveStorage.start()