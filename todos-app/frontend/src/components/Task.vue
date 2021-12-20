<template>
  <div class="card h-100">
    <div class="card-body d-flex flex-column justify-content-between">
      <h5 class="card-title">{{ task.title }}</h5>
      <p class="card-text">{{ task.description }}</p>
      <div class="py-2">
        <span class="text-muted">Priority: </span>
        <span v-if="parseInt(task.priority) === 0" class="badge bg-danger">High</span>
        <span v-else-if="parseInt(task.priority) === 1" class="badge bg-warning">Medium</span>
        <span v-else class="badge bg-info">Low</span>

        <br/>

        <span class="text-muted">Status: </span>
        <span v-if="parseInt(task.status) === 0" class="badge bg-secondary">Not Started</span>
        <span v-else-if="parseInt(task.status) === 1" class="badge bg-primary">In Progress</span>
        <span v-else class="badge bg-success">Done</span>

        <p v-if="task.due_datetime !== null"><span class="text-muted">Due date:</span> {{ (new Date(task.due_datetime)).toLocaleString() }}</p>
      </div>

      <div class="d-flex justify-content-end">
        <button type="button" class="btn btn-primary mx-1" @click="editClicked(task)">Edit</button>
        <button type="button" class="btn btn-danger" @click="deleteClicked(task.id)">Delete</button>
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
    task: Object
  },
  emits: ["edit-clicked", "delete-task"],
  setup(props, { emit }) {
    function editClicked(task) {
      emit("edit-clicked", task)
    }

    function deleteClicked(id) {
      emit("delete-task", id)
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