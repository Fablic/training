class Status {
  static all = {};
  static bySort = [];

  constructor (org) {
    this.id = org.id;
    this.title = org.title;
    this.sort = org.sort;
    this.to_status = org.to_status;
    this.tasks = {};
    this.visible = true;
  }

  static init(statuses) {
    Status.all = {};
    statuses.sort((a, b) => a.sort - b.sort);
    statuses.forEach(statusInfo => {
      const status = new Status(statusInfo);
      status.wrap = document.createElement("div");
      status.wrap.className = "col-lg-2"

      const title = document.createElement("div");
      title.className = "card-title";
      title.innerText = status.title;
      status.wrap.append(title);

      status.dom = document.createElement("div");
      status.wrap.append(status.dom);
      $("#kanban").append(status.wrap);
      Status.all[status.id] = status;
      Status.bySort.push(status);
    });
  }

  static getVisibleIds() {
    const visibleIds = [];
    for (const statusId in Status.all) {
      const status = Status.get(statusId);
      if (status.visible) {
        visibleIds.push(status.id);
      }
    }

    return visibleIds.join(',');
  }

  static get(id) {
    return Status.all[id];
  }

  show() {
    this.visible = true;
    this.wrap.style.display = "block";
    TaskList.dirty = true;

    HashState.set("status", Status.getVisibleIds());
  }

  hide() {
    this.visible = false;
    this.wrap.style.display = "none";
    TaskList.dirty = true;

    HashState.set("status", Status.getVisibleIds());
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
    this.dom.innerHTML = "";
    for (const taskKey in this.tasks) {
      this.attachToDom(this.tasks[taskKey]);
    }
  }

}

class TaskList {
  static all = null;
  static dirty = false;
  static page = 1;

  static async show() {
    let needRefresh = (TaskList.all === null);
    if (TaskList.dirty) {
      needRefresh = true;
    }

    if (needRefresh) {
      await TaskList.refresh();
    }

    $("#kanban").hide();
    $("#listView").show();

    $("#btn_kanban").removeClass("btn-primary");
    $("#btn_list").removeClass("btn-outline-secondary");
    $("#btn_list").addClass("btn-primary");
    $("#btn_kanban").addClass("btn-outline-secondary");
    HashState.isKanbanMode = false;
    HashState.set("viewmode", "list").update();

  }

  static async close() {
    // to kanban mode
    if (Task.all === null) {
      // kanban not initialized
      await Task.init();
    }

    HashState.isKanbanMode = true;
    $("#kanban").show();
    $("#listView").hide();
    
    $("#btn_list").removeClass("btn-primary");
    $("#btn_kanban").removeClass("btn-outline-secondary");
    $("#btn_kanban").addClass("btn-primary");
    $("#btn_list").addClass("btn-outline-secondary");

    HashState.set("viewmode", "kanban").update();
  }

  static async refresh() {
    TaskList.clear();
    await $.ajax({
      url: "/api/board/" + Board.id + "/tasks?sort=" 
          + Board.sort 
          + "&keyword=" + encodeURIComponent(Task.keyword)
          + "&status=" + Status.getVisibleIds()
          + "&page=" + TaskList.page,
      success: function( result ) {
        TaskList.draw(result.tasks);
        TaskList.setPaging(result.paging);
        TaskList.dirty = false;
      }
    });
  }

  static draw(tasks) {
    for (let i=0;i<tasks.length;i++) {
      const t = new Task(tasks[i]);
      TaskList.all[t.id] = t;
      const dom = t.getDomForList();
      $("#tasklist").append(dom);
    }
  }

  static clear() {
    TaskList.all = {};
    $("#tasklist").html('');
  }

  static setDirty() {
    TaskList.dirty = true;
    if (!HashState.isKanbanMode) {
      TaskList.refresh();
    }
  }

  static setPaging(paging) {
    $("#paging").html('');
    for (let i=1; i <= paging.total; i++) {
      const el = document.createElement("li");

      const link = document.createElement("a");
      link.className = "page-link";
      if (paging.current == i) {
        el.className = "page-item active";
      } else {
        el.className = "page-item";
        link.addEventListener("click", event => {
          TaskList.page = i;
          HashState.set("page", i).update();
          TaskList.setDirty();

          event.stopPropagation();
          event.preventDefault();
        
        });
        }
      link.href = "#";
      link.innerText = i;

      el.append(link);
      $("#paging").append(el);
    }
  }
}

class Task {
  static all = null;
  static keyword = "";
  dom = null;
  domForList = null;
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
    Task.all[task.id] = task;
    Status.get(task.status.id).push(task);
    Status.get(task.status.id).attachToDom(task);

  }

  static get(id) {
    if (Task.all === null) {
      return TaskList.all[id];
    }
    return this.all[id];
  }

  static async init() {
    await Task.refresh();
  }

  static filterByTitle(keyword) {
    Task.keyword = keyword;
    TaskList.setDirty();
    for (let id in Task.all) {
      Task.get(id).filterByTitle(keyword);
    }
  
  }

  static async refresh() {
    Task.all = {};

    await $.ajax({
      url: "/api/board/" + Board.id + "/tasks", 
      success: function( result ) {
        for (let i=0;i<result.tasks.length;i++) {
          Task.create(result.tasks[i]);
        }
        return result;
      }
    });
  }

  filterByTitle(keyword) {
    if (keyword === '' || this.title.indexOf(keyword) > -1) {
      this.dom.style.display = 'block';
    } else {
      this.dom.style.display = 'none';
    }
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

  getDomForList() {
    if (this.domForList !== null) {
      return this.domForList;
    }

    this.domForList = document.createElement("tr");
    
    this.updateDomForList();
    this.domForList.dataset.id = this.id;
    this.domForList.addEventListener("click", event => EditModal.openEdit(this.id));
    return this.domForList;  
  }

  updateDomForList() {
    const status = document.createElement("td");
    status.innerText = this.status.title;
    this.domForList.append(status);

    const priorityCol = document.createElement("td");
    const priority = document.createElement("span");
    priority.innerText = this.priority.title;
    priority.style.backgroundColor = "#" + this.priority.color;
    priorityCol.append(priority);
    this.domForList.append(priorityCol);

    const title = document.createElement("td");
    title.innerText = this.title;
    this.domForList.append(title);

    const due_date = document.createElement("td");
    due_date.innerText = this.due_date;
    this.domForList.append(due_date);

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
    let result = 0;
    
    // in case if there is sort property (like status, priority)
    if (valueA.hasOwnProperty("sort")) {
      valueA = valueA.sort;
      valueB = valueB.sort;
    }
    

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

    HashState.set("sort", sort).update();

    // if task is not initialized, pass
    if (Task.all === null) {
      return;
    }

    for (const statusId in Status.all) {
      Status.get(statusId).draw();
    }
    
  }
};

class HashState {
  static current = null;
  static history = [];
  static isKanbanMode = false;

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
        if (Task.all !== null) {
          Task.create(data);
        }
        TaskList.setDirty();
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
        if (Task.all !== null) {
          Task.get(data.id).refresh(data);
        }
        TaskList.setDirty();
  
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
      if (Task.all !== null) {
        Task.get(data.id).remove();
      }
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
    if (Board.sort !== sort) {
      Board.changeSort(sort);
      TaskList.setDirty();
    }
    SortModal.close();
  }
}

class FilterModal {
  static show() {
    Modal.setPosition($("#modal_filter")[0], $("#status_button")[0]);
    $("#modal_background").show();
    $("#modal_filter").show();
    Modal.current = FilterModal;

    FilterModal.clear();
    for (const statusId in Status.all) {
      const status = Status.get(statusId);
      FilterModal.addItem(status.id, status.title, status.visible);
    }
      
  }

  static clear() {
    $("#filter_list").html('');
  }

  static addItem(id, name, selected) {
    const element = document.createElement("li");
    element.className = "list-group-item";
    element.innerText = name;
    element.dataset.id = id;
    element.addEventListener("click", event => FilterModal.clicked(id, element));

    if (selected) {
      element.className += " active";
    }
    $("#filter_list").append(element);
  }

  static close() {
    $("#modal_background").hide();
    $("#modal_filter").hide();
  }

  static clicked(id, element) {
    const status = Status.get(id);
    if (element.className.indexOf('active') > -1) {
      status.hide();
      element.className = "list-group-item";
    } else {
      status.show();
      element.className = "list-group-item active";
    }

    FilterModal.updateButtonText();
    TaskList.setDirty();
  }

  static updateButtonText() {
    let isAll = true;
    const visibleNames = [];
    for (let id in Status.all) {
      if (Status.get(id).visible) {
        visibleNames.push(Status.get(id).title);
      } else {
        isAll = false;
      }
    }

    if (isAll) {
      $("#status_button").text("Status: All");
    } else {
      $("#status_button").text("Status: " + visibleNames.join(", "));
    }
  }
}

class KeywordWatch {
  static last = '';
  static dirty = false;
  static init() {
    const keyword = HashState.get("keyword");
    if (keyword !== null) {
      $("#keyword").val(keyword);
      KeywordWatch.last = keyword;
      Task.keyword = KeywordWatch.last;
    }
    setTimeout(KeywordWatch.tick, 250);
  }

  static tick() {
    const current = $("#keyword").val();
    if (KeywordWatch.dirty === (current === KeywordWatch.last)){
      KeywordWatch.dirty = !KeywordWatch.dirty;
      if (!KeywordWatch.dirty) {
        KeywordWatch.fire(current);
      }
    }

    KeywordWatch.last = current;
    setTimeout(KeywordWatch.tick, 250);
  }

  static fire(keyword) {
    HashState.set("keyword", keyword).update();
    Task.filterByTitle(keyword);
  }
}

