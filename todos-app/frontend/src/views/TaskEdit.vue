<!--Page for editing an existing task-->
<template>
  <div>
    <h1>Edit Task</h1>
    <input v-model="task.title" type="text" placeholder="Input title" required><br/>
    <input v-model="task.description" placeholder="Input description"><br/>
    <select v-model="task.priority">
      <option value="0">High</option>
      <option value="1">Medium</option>
      <option value="2">Low</option>
    </select><br/>
    <select v-model="task.status">
      <option value="0">Not Started</option>
      <option value="1">In Progress</option>
      <option value="2">Done</option>
    </select><br/>
    <input v-model="task.due_datetime" type="datetime-local"><br/>
    <button @click="editTask(task)">Edit Task</button>
  </div>
</template>

<script>
import axios from "axios";
import {onMounted, ref} from "vue";
import {useRoute, useRouter} from "vue-router";

export default {
  name: "TaskEdit",
  setup() {
    const route = useRoute()
    const router = useRouter()
    const task = ref({})

    onMounted(() => {
          axios.get(`http://localhost:3000/tasks/${route.params.id}`).then((response) => {
            task.value = response.data
            // reformats the datetime string, so it's properly displayed in datetime-local typed input
            if (task.value.due_datetime) {
              task.value.due_datetime = task.value.due_datetime.substring(0, 16)
            }
          }).catch(() => {
            alert("Error while fetching task!")
          })
        }
    )

    function editTask(task) {
      axios.put(`http://localhost:3000/tasks/${task.id}`, {task}).then(() => {
        //TODO Flash message is substituted with alert for now. Will be replaced later as Bootstrap is introduced.
        alert("Task edited successfully!")
        router.push({name: "TaskDetail", params: {id: task.id}})
      }).catch(() => {
        alert("Error while editing task!")
      })
    }

    return {
      task,
      editTask
    }
  }
}
</script>
