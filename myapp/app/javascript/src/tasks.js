//document
$(window).ready(function(){
    $(".sort_link_th").click(function (){
        let targetName = $(this).attr("name");
        execSort(targetName);
    });
});

//functions
function execSort(column){
    $(document).ready(function() {

        const sortSelector = $("input[name='search_form[sort]']");
        const orderSelector = $("input[name='search_form[order]']");
        const beforeSortValue = sortSelector.val();

        if (orderSelector.val() == "asc" && beforeSortValue == column) {
            orderSelector.val("desc")
        } else {
            orderSelector.val("asc")
        }
        sortSelector.val(column);
        $("#search_form").submit();
    });
}
