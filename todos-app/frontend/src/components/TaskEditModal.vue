<template>
  <div id="taskEditModal" class="modal fade" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Edit Task</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <form @submit.prevent="editTask">
          <div class="modal-body">
            <label class="form-label">Title</label>
            <input name="title" type="text" class="form-control" :value="task.title" required>

            <label class="form-label mt-4">Description</label>
            <textarea name="description" class="form-control" :value="task.description"></textarea>

            <label class="form-label mt-4">Priority</label>
            <select name="priority" class="form-select" :value="task.priority" required>
              <option disabled selected value="">How urgent?</option>
              <option value="high">High</option>
              <option value="medium">Medium</option>
              <option value="low">Low</option>
            </select>

            <label class="form-label mt-4">Status</label>
            <select name="status" class="form-select" :value="task.status" required>
              <option disabled selected value="">What's the progress?</option>
              <option value="not_started">Not Started</option>
              <option value="in_progress">In Progress</option>
              <option value="done">Done</option>
            </select>

            <label class="form-label mt-4">Due Date</label>
            <input name="due_datetime" type="datetime-local" class="form-control" :value="task.due_datetime ? task.due_datetime.substring(0, 16) : null">

            <label class="form-label mt-4">Tags</label>
            <div class="d-flex flex-wrap">
              <span v-for="(label, i) in labels" :key="i" class="badge rounded-pill badge-outline-secondary m-1">#{{label}}<i type="button" class="bi bi-x" @click="removeLabel(label)"></i></span>
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
            <button type="submit" class="btn btn-primary">Save changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import {onMounted, ref, watch} from "vue";

export default {
  name: "TaskEditModal",
  emits: ["edit-task"],
  props: {
    targetTask: Object,
    targetLabels: Array
  },
  setup(props, {emit}) {
    const task = ref({})
    const labels = ref([])
    const labelInput = ref("")

    watch(() => [props.targetTask, props.targetLabels], () => {
      reset()
    })

    function reset() {
      task.value = props.targetTask
      labels.value = props.targetLabels.map(label => label.name)
    }

    function addLabel() {
      labelInput.value = labelInput.value.replaceAll(" ","")
      labelInput.value = labelInput.value.substr(0, 15)
      labels.value.push(labelInput.value)
      labelInput.value = ""
    }

    function removeLabel(name) {
      labels.value = labels.value.filter(label => label !== name)
    }

    function editTask(event) {
      const editedTask = {
        title: event.target.title.value,
        description: event.target.description.value,
        priority: event.target.priority.value,
        status: event.target.status.value,
        due_datetime: event.target.due_datetime.value || null,
        labels: labels.value
      }
      emit("edit-task", task.value.id, editedTask)
    }

    onMounted(() => {
      // reset form data to what it was before if not saved
      document.getElementById("taskEditModal").addEventListener('hidden.bs.modal', () => {
        reset()
      })
    })

    return {
      task,
      labelInput,
      labels,
      reset,
      addLabel,
      removeLabel,
      editTask,
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
