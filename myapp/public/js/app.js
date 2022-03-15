class Status {
  static all = {};
  static bySort = [];

  constructor (org) {
    this.id = org.id;
    this.title = org.title;
    this.sort = org.sort;
    this.to_status = org.to_status;
    this.tasks = {};
  }

  static init(statuses) {
    Status.all = {};
    statuses.sort((a, b) => a.sort - b.sort);
    statuses.forEach(statusInfo => {
      const status = new Status(statusInfo);
      const wrap = document.createElement("div");
      wrap.className = "col-lg-2"

      const title = document.createElement("div");
      title.className = "card-title";
      title.innerText = status.title;
      wrap.append(title);

      status.dom = document.createElement("div");
      wrap.append(status.dom);
      $("#kanban").append(wrap);
      Status.all[status.id] = status;
      Status.bySort.push(status);
    });
  }

  static get(id) {
    return Status.all[id];
  }

  push(task) {
    this.tasks[task.id] = task;
  }

  remove(taskId) {
    delete this.tasks[taskId];
  }

  attachToDom(task) {
    // todo: apply second key for identical value
    for (let i=0; i < this.dom.children.length; i++) {
      const target = this.dom.children[i];

      if (task.compareSort(Task.get(target.dataset.id)) < 0) {
        this.dom.insertBefore(task.getDom(), target);
        return;
      }
    }
    this.dom.append(task.getDom());
  }

  detachFromDom(task) {
    this.dom.removeChild(task.getDom());
  }

  draw() {
    for (const taskKey in this.tasks) {
      this.attachToDom(this.tasks[taskKey]);
    }
  }

  redraw() {
    this.dom.innerHTML = "";
    this.draw();
  }
}

class Task {
  static all = null;
  dom = null;
  constructor (org) {
    this.id = org.id;
    this.status = org.status;
    this.priority = org.priority;
    this.tags = org.tag;
    this.contents = org.contents;
    this.title = org.title;
    this.due_date = org.due_date;
    this.created_at = org.created_at;
    this.dom = null;
    
  }

  static create(org) {
    let task = new Task(org);
    Status.get(task.status.id).push(task);
    Status.get(task.status.id).attachToDom(task);
    Task.all[task.id] = task;

  }

  static get(id) {
    return this.all[id];
  }

  static async init() {
    await Task.refresh();
  }

  static async refresh() {
    Task.all = {};
    await $.ajax({
      url: "/api/board/" + Board.id + "/tasks", 
      success: function( result ) {
        for (let i=0;i<result.length;i++) {
          Task.create(result[i]);
        }
        return result;
      }
    });
  }

  getDom() {
    if (this.dom !== null) {
      return this.dom;
    }

    this.dom = document.createElement("div");
    this.dom.className = "card";

    const status = document.createElement("div");
    status.className = "status";
    this.dom.append(status);

    const priority = document.createElement("span");
    priority.className = "priority";
    priority.innerText = this.priority.title;
    priority.style.backgroundColor = "#" + this.priority.color;
    status.append(priority);

    const title = document.createElement("div");
    title.className = "title";
    title.innerText = this.title;
    this.dom.append(title);

    const contents = document.createElement("div");
    contents.className = "cont";
    contents.innerText = this.contents;
    this.dom.append(contents);

    const due_date = document.createElement("div");
    due_date.className = "due_date";
    due_date.innerText = "Due Date: " + this.due_date;
    this.dom.append(due_date);
    
    this.dom.dataset.id = this.id;
    this.dom.addEventListener("click", event => EditModal.openEdit(this.id));
    return this.dom;
  }

  refresh(org) {
    const oldStatusId = this.status.id;
    this.status = org.status;
    this.priority = org.priority;
    this.tags = org.tag;
    this.contents = org.contents;
    this.title = org.title;
    this.due_date = org.due_date;
    
    const oldStatus = Status.get(oldStatusId);
    const newStatus = Status.get(this.status.id);

    if (this.dom !== null) {
      oldStatus.detachFromDom(this);
      oldStatus.remove(this);
      this.dom = null;
      newStatus.push(this);
      newStatus.attachToDom(this);
    } else {
      oldStatus.remove(this);
      newStatus.push(this);
    }
  }

  remove() {
    const oldStatusId = this.status.id;
    const oldStatus = Status.get(oldStatusId);

    if (this.dom !== null) {
      oldStatus.detachFromDom(this);
    }

    oldStatus.remove(this);

  }

  // compare function
  compareSort(target) {
    let sort = Board.sort;
    let reversed = false;
    if (sort.substring(0,1) === '-') {
      reversed = true;
      sort = sort.substring(1);
    }

    let valueA = this[sort];
    let valueB = target[sort];
    
    // in case if there is sort property (like status, priority)
    if (valueA.hasOwnProperty("sort")) {
      valueA = valueA.sort;
      valueB = valueB.sort;
    }
    

    let result = 0;
    if (valueA < valueB) {
      result = -1;
    } else if (valueA > valueB) {
      result = 1;
    } else {
      // make id as second key 
      result = this.id - target.id;
    }

    if (reversed) {
      result *= -1;
    }

    return result;
  }


}

class Board {
  static async init(board_id) {
    Board.id = board_id
    await Board.refresh();
  }

  static async refresh() {
    await $.ajax({
      url: "/api/board/" + Board.id, 
      success: function( result ) {
        Board.priorities = result.priority;
        Board.priorities.sort((a, b) => a.sort - b.sort);
        Board.tags = result.tag;
        Status.init(result.status);
        return true;
      }
    });
  }

  static draw() {
    Status.bySort.forEach(status => status.draw());
  }

  static changeSort(sort) {
    Board.sort = sort;

    // find current sort name and set sort button text
    const sortOptions = $("#modal_sort").children();
    for (let i=0; i < sortOptions.length; i++) {
      if (sortOptions[i].dataset.sort_type === sort) {
        $("#sort_button").text(sortOptions[i].innerText);
        break;
      }
    }

    // if task is not initialized, pass
    if (Task.all === null) {
      return;
    }

    HashState.set("sort", sort).update();
    for (const statusId in Status.all) {
      Status.get(statusId).redraw();
    }
    
  }
};

class HashState {
  static current = null;
  static history = [];

  static init() {
    HashState.current = {};
    window.location.hash.substring(1).split("&").forEach(
      (hash) => {
        if (hash === "") return;
        const hashArray = hash.split("=");
        if (hashArray.length == 1) {
          HashState.current[hashArray[0]] = undefined;
        } else {
          HashState.current[hashArray[0]] = hashArray[1];
        }
      }
    );
  }

  static set(key, value) {
    HashState.current[key] = value;
    HashState.update();
    return HashState;
  }

  static push() {
    HashState.history.push(window.location.hash);
    return HashState;
  }

  static pop() {
    const old = HashState.history.pop();
    if (typeof(old) === "undefined") {
      return;
    }

    window.location.hash = old;
    HashState.init();
    return HashState;
  }

  static remove(key) {
    delete HashState.current[key];
    return HashState;
  }

  static clear() {
    HashState.current = {};
    return HashState;
  }

  static has(key) {
    return key in HashState.current;
  }

  static get(key) {
    if (!HashState.has(key)) {
      return null;
    }

    return HashState.current[key];
  }

  static update() {
    let out = "";
    for (const [key, value] of Object.entries(HashState.current)) {
      if (out === "") {
        out = "#" + key;
      } else {
        out += "&" + key;
      }
      if (typeof(value) !== "undefined") {
        out += "=" + value;
      }
    }

    window.location.hash = out;
    return HashState;
  }
}

class Modal {
  static current = null;
  static maskClicked() {
    Modal.current.close();
  }

  static setPosition(target, reference) {
    const refRect = reference.getBoundingClientRect();
    target.style.left = refRect.x + "px";
    target.style.top = refRect.y + "px";
  }
}

class EditModal {
  static inited = false;

  static init() {
    EditModal.inited = true;
    $('#edit_due_date').datetimepicker();

    // status options
    $("#edit_status").empty();
    Status.bySort.forEach(status => {
      let option = document.createElement("option");
      option.value = status.id;
      option.innerText = status.title;
      
      $("#edit_status").append(option);
    });

    // priority options
    $("#edit_priority").empty();
    Board.priorities.forEach(priority => {
      let option = document.createElement("option");
      option.value = priority.id;
      option.innerText = priority.title;
      
      $("#edit_priority").append(option);
    });

  }
  
  static openNew() {
    EditModal.clear();
    $("#edit_id").val(0)
    EditModal.show();
    HashState.push().clear().set("create").update();
  }

  static openEdit(taskId) {
    EditModal.clear();
    const task = Task.get(taskId);

    $("#edit_status option").attr('disabled', true);
    
    // available next status
    const status_enabled = Status.get(task.status.id).to_status;
    for (let i=0; i < status_enabled.length; i++) {
      $('#edit_status option[value="' + status_enabled[i].id + '"]').attr('disabled', false);
    }
    
    // by default current status is usable.
    $('#edit_status option[value="' + task.status.id + '"]').attr('disabled', false);

    $("#edit_id").val(task.id)
    $("#edit_title").val(task.title)
    $("#edit_contents").val(task.contents)
    $("#edit_priority").val(task.priority.id)
    $("#edit_status").val(task.status.id)
    $("#edit_due_date").val(task.due_date)

    //$("#edit_status option")


    HashState.push().clear().set("modify").set("id", task.id).update();
    EditModal.show();
  }

  static show() {
    $("#modal_background").show();
    $("#modal_edit").show();
    EditModal.updateErrorMsg();
    Modal.current = EditModal;
    
  }

  static close() {
    $("#modal_background").hide();
    $("#modal_edit").hide();
    HashState.pop();
  }

  static clear() {
    if (!EditModal.inited) {
      EditModal.init();
    }

    $("#edit_status option").attr('disabled', false);
    $("#form_edit")[0].reset();
  }

  static save() {
    if ($("#edit_id").val() === "0") {
      $.ajax({
        type: "POST",
        beforeSend(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        },
        url: "/api/board/" + Board.id + "/task",
        data: {
          "task":{
            "title": $("#edit_title").val(),
            "status_id": $("#edit_status").val(),
            "priority_id": $("#edit_priority").val(),
            "contents": $("#edit_contents").val(),
            "due_date": $("#edit_due_date").val(),
            "status_id": $("#edit_status").val(),
          }
        },
        dataType : "json"
      }).done(function(data){
        if (typeof(data.error) !== "undefined") {
          EditModal.updateErrorMsg(data.error);
          return
        }
        Task.create(data);
        EditModal.close();
      }).fail(function(XMLHttpRequest, status, e){
        alert(e);
      });
    } else {
      $.ajax({
        type: "PATCH",
        beforeSend(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        },
        url: "/api/task/" + $("#edit_id").val(),
        data: {
          "task": {
            "title": $("#edit_title").val(),
            "status_id": $("#edit_status").val(),
            "priority_id": $("#edit_priority").val(),
            "contents": $("#edit_contents").val(),
            "due_date": $("#edit_due_date").val(),
            "status_id": $("#edit_status").val(),
          }
        },
        dataType : "json"
      }).done(function(data){
        if (typeof(data.error) !== "undefined") {
          EditModal.updateErrorMsg(data.error);
          return
        }
        Task.get(data.id).refresh(data);
        EditModal.close();
      }).fail(function(XMLHttpRequest, status, e){
        alert(e);
      });
    }
  }

  static updateErrorMsg(errors) {
    // clear all errors
    $("#modal_edit .form-control").removeClass("is-invalid");
    $("#modal_edit .form-select").removeClass("is-invalid");
    $("#modal_edit .invalid-feedback").text('');
    if (typeof(errors) === "undefined") {
      return;
    }
    
    for (const [key, messages] of Object.entries(errors)) {
      $("#edit_" + key).addClass("is-invalid");
      $("#edit_" + key + "_message").text(messages.join(","));
    }

  }

  static remove() {
    $.ajax({
      type: "DELETE",
      beforeSend(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      url: "/api/task/" + $("#edit_id").val(),
      dataType : "json"
    }).done(function(data){
      Task.get(data.id).remove();
      EditModal.close();
    }).fail(function(XMLHttpRequest, status, e){
      alert(e);
    });
  }
}

class SortModal {
  static show() {
    Modal.setPosition($("#modal_sort")[0], $("#sort_button")[0]);
    $("#modal_background").show();
    $("#modal_sort").show();
    Modal.current = SortModal;
    
  }

  static close() {
    $("#modal_background").hide();
    $("#modal_sort").hide();
  }

  static apply(sort) {
    Board.changeSort(sort);
    SortModal.close();
  }
}
