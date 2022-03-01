window.addEventListener('DOMContentLoaded', (elemnt) => {
    let taskTicket = document.querySelectorAll('.task-ticket');
    let dragged;

    taskTicket.forEach(function(el, i) {
        el.addEventListener('click', function() {
            let ticketId = el.innerText.split('\n')[0].replace('#', '');
            window.location = 'tasks/' + ticketId
        });

        el.addEventListener('dragstart', function(e) {
            e.target.style.opacity = 0.5;
            dragged = e.target;
        });

        el.addEventListener('dragend', function(e) {
            e.target.style.opacity = 1;
        });
    });

    document.addEventListener('dragenter', function(e) {
        if (e.target.classList.value === "trash-box") {
            e.target.style.opacity = 0.5;
        }
    });

    document.addEventListener('dragleave', function(e) {
        if (e.target.classList.value === "trash-box") {
            e.target.style.opacity = 1;
        }
    });

    document.addEventListener('dragover', function(e) {
        e.preventDefault();
    });

    document.addEventListener('drop', function(e) {
        e.preventDefault();
        if (e.target.classList.value === "trash-box") {
            let result = confirm('本当に削除しますか？')
            if (result) {
                let taskId = dragged.innerText.split('\n')[0].replace('#', '');
                $.ajax({
                        url: 'api/tasks/' + taskId + '/delete',
                        type: 'get',
                        cache: false,
                        dataType: 'json',
                    })
                    .done(function(response) {
                        dragged.parentNode.removeChild(dragged);
                    })
                    .fail(function(xhr) {
                        //通信失敗時の処理
                    });
            }
            e.target.style.opacity = 1;
        }
    });


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
});
