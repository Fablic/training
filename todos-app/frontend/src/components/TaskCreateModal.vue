<template>
  <div class="modal fade" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Create Task</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <form @submit.prevent="createTask(task)">
          <div class="modal-body">
            <label class="form-label">Title</label>
            <input type="text" class="form-control" placeholder="What is the task?" v-model="task.title" required>

            <label class="form-label mt-4">Description</label>
            <textarea class="form-control" placeholder="What is it about?" v-model="task.description"/>

            <label class="form-label mt-4">Priority</label>
            <select class="form-select" v-model="task.priority" required>
              <option disabled selected value="">How urgent?</option>
              <option value="high">High</option>
              <option value="medium">Medium</option>
              <option value="low">Low</option>
            </select>

            <label class="form-label mt-4">Status</label>
            <select class="form-select" v-model="task.status" required>
              <option disabled selected value="">What's the progress?</option>
              <option value="not_started">Not Started</option>
              <option value="in_progress">In Progress</option>
              <option value="done">Done</option>
            </select>

            <label class="form-label mt-4">Due Date</label>
            <input type="datetime-local" class="form-control" v-model="task.due_datetime">

            <label class="form-label mt-4">Tags</label>
            <div class="d-flex flex-wrap">
              <span v-for="(label, i) in task.labels" :key="i" class="badge rounded-pill badge-outline-secondary m-1">#{{label}}<i type="button" class="bi bi-x" @click="removeLabel(label)"></i></span>
            </div>
            <div class="input-group">
              <input name="label" type="text" class="form-control" placeholder="Max 15 characters without space" v-model="labelInput">
              <button type="button" class="btn btn-outline-secondary input-group-text" @click="addLabel">
                <i class="bi bi-plus-circle"></i>
              </button>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary">Create</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import {ref} from "vue";

export default {
  name: "TaskCreateModal",
  emits: ["create-task"],
  setup(props, {emit}) {
    const task = ref({
      status: "",
      priority: "",
      due_datetime: null,
      updated_at: new Date(),
      labels: [],
    })
    const labelInput = ref("")

    function addLabel() {
      labelInput.value = labelInput.value.replaceAll(" ","")
      labelInput.value = labelInput.value.substr(0, 15)
      task.value.labels.push(labelInput.value)
      labelInput.value = ""
    }

    function removeLabel(name) {
      task.value.labels.value = task.value.labels.filter(label => label !== name)
    }

    function createTask(task) {
      emit("create-task", task)
    }

    return {
      task,
      labelInput,
      addLabel,
      removeLabel,
      createTask,
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
