// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("admin-lte");
import 'bootstrap';
import "@fortawesome/fontawesome-free/js/all";
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

require('flatpickr')
const japan = require("flatpickr/dist/l10n/ja.js").default.ja;
$(document).on("turbolinks:load", () => {
  const date_config = {
    locale: japan
  }
  $(".datepickr").flatpickr(date_config);
  
  const time_config = {
    enableTime: true,
    noCalendar: true,
    dateFormat: "H:i",
    time_24hr: true
  }
  $(".timepickr").flatpickr(time_config);
})

// stylesheets
require("../stylesheets/application.scss")
var jQuery = require('jquery')
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

import '../stylesheets/application';


Rails.start()
Turbolinks.start()
ActiveStorage.start()
