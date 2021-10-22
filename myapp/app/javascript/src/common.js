import "select2"
import flatpickr from "flatpickr";
import {Japanese} from "flatpickr/dist/l10n/ja";

$(window).ready(function(){
    flatpickr(".calendar",{"locale":Japanese})
    $('.select2').select2();
});
