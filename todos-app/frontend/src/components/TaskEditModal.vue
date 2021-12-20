<template>
  <div class="modal fade" tabindex="-1" aria-hidden="true">
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
              <option value="0">High</option>
              <option value="1">Medium</option>
              <option value="2">Low</option>
            </select>

            <label class="form-label mt-4">Status</label>
            <select name="status" class="form-select" :value="task.status" required>
              <option disabled selected value="">What's the progress?</option>
              <option value="0">Not Started</option>
              <option value="1">In Progress</option>
              <option value="2">Done</option>
            </select>

            <label class="form-label mt-4">Due Date</label>
            <input name="due_datetime" type="datetime-local" class="form-control" :value="task.due_datetime ? task.due_datetime.substring(0, 16) : null">
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
import {toRefs} from "vue";

export default {
  name: "TaskEditModal",
  emits: ["edit-task"],
  props: {
    targetTask: Object
  },
  setup(props, { emit }) {
    const task = toRefs(props).targetTask

    function editTask(event) {
      const editedTask = {
        title: event.target.title.value,
        description: event.target.description.value,
        priority: event.target.priority.value,
        status: event.target.status.value,
        due_datetime: event.target.due_datetime.value || null,
      }
      emit("edit-task", task.value.id, editedTask)
    }

    return {
      task,
      editTask,
    }
  }
}
</script>

<style scoped>

</style>