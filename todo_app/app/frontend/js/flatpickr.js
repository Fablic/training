import flatpickr from "flatpickr";
import 'flatpickr/dist/flatpickr.css';

document.addEventListener("turbolinks:load", () => {
    flatpickr('#flatpickr-datetime', {
        enableTime: true
    });
})
