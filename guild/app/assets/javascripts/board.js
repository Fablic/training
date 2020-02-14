'use strict';
let taskDetail;
let taskList;
let master;
let conditions = {};
let pagination = new Pagination();

window.addEventListener('DOMContentLoaded', function() {
  prepare();

  document.getElementById("search-task").onclick = function() {
    conditions["label"] = $("#condition-label").val();
    conditions["state"] = $("#condition-state").val();
    getLatestTaskList(true)
  }

  document.getElementById("change-input").onclick = function() {
    resetModal()
    $("#state-form-group").show();
    $("#subject").val(taskDetail.subject);
    $("#description").val(taskDetail.description);
    $("#priority").val(taskDetail.priority);
    $("#label").val(taskDetail.label);
    $("#state").val(taskDetail.state);

    $('#modal-body-input').show();
    $('#modal-title').text(I18n.t('views.change_task'));
    $('#change-task').show();
    return
  }
  document.getElementById("change-task").onclick = function() {
    const subject     = $("#subject").val();
    const description = $("#description").val();
    const priority    = $("#priority").val();
    const label       = $("#label").val();
    const state       = $("#state").val();

    $.ajax({
      url: '/board/api/task/' + taskDetail.id,
      type: 'put',
      dataType: 'json',
      data: {
        subject: subject,
        description: description,
        priority: priority,
        label: label,
        state: state,
      },
      success: function(data) {
        console.log(data)
        $.LoadingOverlay("show");
        getLatestTaskList()
        $('#modal-window').modal('hide')
        $.LoadingOverlay("hide");
        viewCompleteMessage(I18n.t('views.message.change_complete') + ' [id:' + taskDetail.id + ']');
        return;
      },
      error: function(data) {
        console.log(data)
      }
    });
  }
  // Delete task
  document.getElementById("delete-task").onclick = function() {
    $.ajax({
      url: '/board/api/task/' + $('#delete-id').val(),
      type: 'delete',
      success: function(data) {
        console.log(data)
        $.LoadingOverlay("show");
        getLatestTaskList(true)
        $('#modal-window').modal('hide')
        $.LoadingOverlay("hide");
        viewCompleteMessage(I18n.t('views.message.delete_complete'));
      },
      error: function(data) {
        console.log(data)
      }
    });
    return;
  };

  // Add task
  document.getElementById("add-task").onclick = function() {
    const subject     = $("#subject").val();
    const description = $("#description").val();
    const priority    = $("#priority").val();
    const label       = $("#label").val();

    $.ajax({
      url: '/board/api/task',
      type: 'post',
      dataType: 'json',
      data: {
        subject: subject,
        description: description,
        priority: priority,
        label: label,
      },
      success: function(data) {
        console.log(data.result)
        $.LoadingOverlay("show");
        getLatestTaskList(true)
        $('#modal-window').modal('hide')
        $.LoadingOverlay("hide");
        viewCompleteMessage(I18n.t('views.message.create_complete'));
      },
      error: function(data) {
        console.log(data)
      }
    });
  };
});

const getLatestTaskList = (reset = false) => {
  $.ajax({
    url: '/board/api/task/all',
    type: 'get',
    data: {conditions: conditions},
    success: function(data) {
      console.log(data)
      taskList = data.response.task_list
      createTaskListElements()
      if (taskList.length > 0) {
        pagination.init({
          total:  data.response.total,
          limit:  data.response.limit,
          apiUrl: '/board/api/task/all',
          callback: paginationCallback,
          queryParams: {conditions: conditions},
        }, reset);
      }
    },
    error: function(data) {
      console.log(data)
    }
  });
}

const paginationCallback = data => {
  console.log(data)
  taskList = data.response.task_list
  createTaskListElements()
}

const createTaskListElements = () => {
  const elTaskList = $("#task-list-doby");
  elTaskList.empty();
  taskList.forEach(function(task,index,ar){
    var elTr = $("<tr></tr>");
    if (task.priority == 1) {
      var priorityColor = 'info';
    } else if(task.priority == 2) {
      var priorityColor = 'warning';
    } else if(task.priority == 3) {
      var priorityColor = 'danger';
    }
    elTr.append('<th scope="row" ><a id="id-link-' + task.id + '" href="javascript:openInfoModalWindow(' + task.id + ');">' + task.id + '</a></td>');
    elTr.append("<td>" + task.user_id + "</td>");
    elTr.append("<td>" + master.label[task.label] + "</td>");
    var elTdSubject = $("<td></td>");
    elTdSubject.text(task.subject);
    elTr.append(elTdSubject);
    elTr.append('<td><p class="text-' + priorityColor + '">' + master.priority[task.priority] + '</p></td>');
    elTr.append("<td>" + master.state[task.state] + "</td>");
    elTr.append("<td>" + task.created_at + "</td>");
    elTr.append("<td>" + task.updated_at + "</td>");
    elTr.append('<td><button type="button" id="button-delete-' + task.id + '" class="btn btn-danger" onClick="javascript:openDeleteModalWindow(' + task.id + ');">Delete</button></td>');
    elTaskList.append(elTr);
  });
}

const prepare = () => {
  const el = document.getElementById('task-list-doby');
  const sortable = Sortable.create(el, {
    ghostClass: 'dragging',
    animation: 150,
  });
  $.ajax({
    url: '/board/api/master/all',
    type: 'get',
    success: function(data) {
      console.log(data)
      master = data.response;
      getLatestTaskList(true);
    },
    error: function(data) {
      console.log(data)
    }
  });
}

const openAddingeModalWindow = () => {
  resetModal()
  $('#modal-body-input').show();
  $('#modal-title').text(I18n.t('views.create_task'));
  $('#add-task').show();
  $('#modal-window').modal('show')
  return;
}

const openInfoModalWindow = id => {
  resetModal()
  $('#modal-body-info').show();
  $('#modal-title').text(I18n.t('views.task_detail'));
  $('#change-input').show();
  $.ajax({
    url: '/board/api/task/' + id,
    type: 'get',
    success: function(data) {
      console.log(data)
      taskDetail = data.response.task;
      $('#info-label').text(master.label[data.response.task.label])
      $('#info-subject').text(data.response.task.subject)
      $('#info-description').text(data.response.task.description)
      $('#info-priority').text(master.priority[data.response.task.priority])
      $('#info-state').text(master.state[data.response.task.state])
      $('#modal-window').modal('show')
    },
    error: function(data) {
      console.log(data)
    }
  });
  return;
}

const openDeleteModalWindow = id => {
  resetModal()
  $('#modal-body-message').show();
  $('#delete-id').val(id);
  $('#modal-title').text(I18n.t('views.delete_task'));
  $('#delete-task').show();
  $('#modal-window').modal('show')
  return;
}

const resetModal = () => {

  // hide body elements
  $('#modal-body-message').hide();
  $('#modal-body-info').hide();
  $('#modal-body-input').hide();

  // hide buttons
  $('#add-task').hide();
  $('#change-task').hide();
  $('#change-input').hide();
  $('#delete-task').hide();

  // reset input forms
  $('#modal-title').text("");
  $("#subject").val("");
  $("#description").val("");
  $("#priority").val("");
  $("#label").val("");
  $("#state-form-group").hide();
  return;
}

const viewCompleteMessage = message => {
  $('#alert-complete').text(message);
  $('#alert-complete').show();
}
