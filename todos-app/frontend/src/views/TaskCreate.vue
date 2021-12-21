<!--Page for creating a new task-->
<template>
  <div>
    <h1>New Task</h1>
    <span>Title</span><br/>
    <input v-model="newTask.title" type="text" placeholder="Input title" required><br/>
    <span>Description</span><br/>
    <input v-model="newTask.description" placeholder="Input description"><br/>
    <span>Priority</span><br/>
    <select v-model="newTask.priority">
      <option value="0">High</option>
      <option value="1">Medium</option>
      <option value="2">Low</option>
    </select><br/>
    <span>Status</span><br/>
    <select v-model="newTask.status">
      <option value="0">Not Started</option>
      <option value="1">In Progress</option>
      <option value="2">Done</option>
    </select><br/>
    <span>Due date</span><br/>
    <input v-model="newTask.due_datetime" type="datetime-local"><br/>
    <button @click="createTask(newTask)">Create Task</button>
  </div>
</template>

<script>
import axios from "axios";
import {ref} from "vue";
import {useRouter} from "vue-router";

export default {
  name: "TaskCreate",
  setup() {
    const router = useRouter()
    const newTask = ref({
      //TODO Needs to be assigned dynamically as user function is implemented
      user_id: 1,
      priority: 0,
      status: 0,
      due_datetime: null
    })

    function createTask(task) {
      axios.post(process.env.VUE_APP_TASK_SERVICE_BASE_URL + "/tasks", {task}).then(() => {
        //TODO Flash message is substituted with alert for now. Will be replaced later as Bootstrap is introduced.
        alert("Task created successfully!")
        router.push({name: "TaskIndex"})
      }).catch(() => {
        alert("Error while creating task!")
      })
    }

    return {
      newTask,
      createTask
    }
  }
}
</script>
