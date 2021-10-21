//document
$(window).ready(function(){
    $(".sort_link_th").click(function (){
        const targetName = $(this).attr("name");
        execSort(targetName);
    });
});

//functions
function execSort(column){
    const sortSelector = $("input[name='search_form[sort]']");
    const orderSelector = $("input[name='search_form[order]']");
    const beforeSortValue = sortSelector.val();
    orderSelector.val(orderSelector.val() == "asc" && beforeSortValue == column ? "desc" : "asc");
    sortSelector.val(column);
    $("#search_form").submit();
}
