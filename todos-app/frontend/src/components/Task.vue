<template>
  <div class="card h-100">
    <div class="card-body d-flex flex-column justify-content-between">
      <div class="d-flex justify-content-between">
        <h5 class="card-title">{{ task.title }}</h5>
        <div v-if="enableEdit" class="d-flex justify-content-end">
          <i type="button" class="bi bi-pencil-square mx-2" @click="editClicked(task)"></i>
          <i type="button" class="bi bi-trash" @click="deleteClicked(task.id)"></i>
        </div>
      </div>
      <p class="card-text">{{ task.description }}</p>
      <div class="py-1">
        <span class="text-muted">Priority: </span>
        <span v-if="task.priority === 'high'" class="badge bg-danger">High</span>
        <span v-else-if="task.priority === 'medium'" class="badge bg-warning">Medium</span>
        <span v-else class="badge bg-info">Low</span>

        <br/>

        <span class="text-muted">Status: </span>
        <span v-if="task.status === 'not_started'" class="badge bg-secondary">Not Started</span>
        <span v-else-if="task.status === 'in_progress'" class="badge bg-primary">In Progress</span>
        <span v-else class="badge bg-success">Done</span>

        <p v-if="task.due_datetime !== null"><span class="text-muted">Due date:</span> {{ (new Date(task.due_datetime)).toLocaleString() }}</p>
      </div>
      <div class="d-flex flex-wrap">
        <span v-for="label in task.labels" :key="label.name" class="badge rounded-pill badge-outline-secondary m-1">#{{label.name}}</span>
      </div>
    </div>
    <div class="card-footer">
      <small class="text-muted">Last updated at: {{ getLastUpdatedString(new Date(), new Date(task.updated_at)) }}</small>
    </div>
  </div>
</template>

<script>

export default {
  name: "Task",
  props: {
    enableEdit: Boolean,
    task: Object
  },
  emits: ["edit-clicked", "delete-clicked"],
  setup(props, {emit}) {
    function editClicked(task) {
      emit("edit-clicked", task)
    }

    function deleteClicked(id) {
      emit("delete-clicked", id)
    }

    function getLastUpdatedString(baseTime, targetTime) {
      let diffInSec = (baseTime - targetTime) / 1000
      if (diffInSec < 60) {
        return "less than a minute ago"
      } else if (60 < diffInSec && diffInSec < 60 * 60) {
        return parseInt(diffInSec / 60) + " minutes ago"
      } else if (60 * 60 < diffInSec && diffInSec < 60 * 60 * 24) {
        return parseInt(diffInSec / 60 / 60) + " hours ago"
      } else{
        return parseInt(diffInSec / 60 / 60 / 24) + " days ago"
      }
    }

    return {
      editClicked,
      deleteClicked,
      getLastUpdatedString
    }
  }
}
</script>

<style scoped>
.badge-outline-secondary {
  color: #6c757d;
  background-color: transparent;
  background-image: none;
  border: 1px solid #6c757d;
}
</style>
