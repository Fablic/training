window.addEventListener('DOMContentLoaded', (elemnt) => {
    createBtnEvent()

    $.ajax({
        url: 'api/tasks/board',
        type: 'get',
        cache: false,
        dataType: 'json',
    })
    .done(function(response) {
        const kanban = createBoardData(response)
        setStatusColor();
    })
    .fail(function(xhr) {
    });
});

function setStatusColor() {
    const data = document.querySelectorAll('[data-status]');
    data.forEach(el => {
        if (el.dataset.status == "not_started") {
            el.style.backgroundColor = "#dd8383"
        }

        if (el.dataset.status == "start") {
            el.style.backgroundColor = "#70b251"
        }

        if (el.dataset.status == "done") {
            el.style.backgroundColor = "gray"
        }
    });
}

function createBtnEvent() {
    let createBtn = document.querySelector('.create-task-ticket');

    createBtn.addEventListener('mouseover', function() {
        createBtn.style.opacity = 0.7;
    });

    createBtn.addEventListener('mouseleave', function() {
        createBtn.style.opacity = 1;
    });

    createBtn.addEventListener('click', function(e) {
        window.location = 'tasks/new';
    });
}

function createBoardData(data) {
    return new jKanban({
        element         : '#myKanban',
        gutter          : '15px',
        widthBoard      : '25%',
        responsivePercentage : true,
        click : function (el) {
            window.location = "tasks/" + el.dataset.taskid
        },
        dropEl: function (el, target, source, sibling) {
            var Order = target.parentNode.dataset.order

        },
        boards: data,
    });
}

