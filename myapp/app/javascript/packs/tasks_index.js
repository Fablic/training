window.addEventListener('DOMContentLoaded', (elemnt) => {
    createBtnEvent()

    $.ajax({
        url: 'api/tasks/board',
        type: 'get',
        cache: false,
        dataType: 'json',
    })
    .done(function(response) {
        let data = [
            {
                "id": "sample-board-1",
                "title": "第1優先グループ",
                "class": "task",
                "item": [
                    {
                        "title": "報告書の作成",
                        "status" : "not-tarted",
                        "taskId" : "43"
                    },
                    {
                    "title": "14時から打ち合わせ",
                    "status" : "start",
                    "taskId" : "43"
                    }
                ]
            },

            {
                "id": "sample-board-100",
                "title": "第2優先グループ",
                "class": "progress",
                "item": [
                    {
                    "title": "○○案の企画書作成",
                    "status" : "done",
                    "taskId" : "43"
                    }
                ]
            },

            {
                "id": "sample-board-3",
                "title": "第3優先グループ",
                "class": "done",
                "item": [{ "title": "日報の提出" }]
            },

            {
                "id": "sample-board-4",
                "title": "第4優先グループ",
                "class": "test",
                "item": [{ "title": "日報の提出" }]
            }
        ];
        const kanban = createBoardData(data)
        setStatusColor();
    })
    .fail(function(xhr) {
    });
});

function setStatusColor() {
    const data = document.querySelectorAll('[data-status]');
    data.forEach(el => {
        if (el.dataset.status == "not_started") {
            el.style.backgroundColor = "red"
        }

        if (el.dataset.status == "start") {
            el.style.backgroundColor = "green"
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

