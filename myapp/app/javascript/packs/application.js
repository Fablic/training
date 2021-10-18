import '@fortawesome/fontawesome-free/js/all';

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require("jquery")
import flatpickr from "flatpickr";
const japanese = require("flatpickr/dist/l10n/ja").default.ja;
document.addEventListener("turbolinks:load", () => {
    flatpickr("[class='calendar']", japanese)
});
require("../stylesheets/application.scss")
