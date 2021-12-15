<!--Page for displaying a task's details-->
<template>
  <div>
    <h1> {{ task.title }} </h1>
    <p> {{ task.description }} </p>
    <span> <b>Status</b>: {{ getStatus(task.status) }}</span> |
    <span> <b>Priority</b>: {{ getPriority(task.priority) }}</span> |
    <span> <b>Due date</b>: {{ task.due_datetime }} </span><br>
    <button @click="$router.push({name: 'TaskEdit', params: {id: task.id }})">Edit</button>
    <button @click="deleteTask(task.id)">Delete</button>
  </div>
</template>

<script>

import {onMounted, ref} from "vue";
import axios from "axios";
import {useRoute, useRouter} from "vue-router";

export default {
  name: "TaskDetail",
  setup() {
    const route = useRoute()
    const router = useRouter()
    const task = ref({})

    onMounted(() => {
          axios.get(`http://localhost:3000/tasks/${route.params.id}`).then((response) => {
            task.value = response.data
          }).catch(() => {
            alert("Error while fetching task!")
          })
        }
    )

    function getStatus(status) {
      switch (status) {
        case 0:
          return "Not Started"
        case 1:
          return "In Progress"
        case 2:
          return "Done"
        default:
          return "Unknown"
      }
    }

    function getPriority(priority) {
      switch (priority) {
        case 0:
          return "High"
        case 1:
          return "Medium"
        case 2:
          return "Low"
        default:
          return "Unknown"
      }
    }

    function deleteTask(id) {
      axios.delete(`http://localhost:3000/tasks/${id}`).then(() => {
        alert("Task deleted successfully!")
        router.push({name: "TaskIndex"})
      }).catch(() => {
        alert("Error while deleting task!")
      })
    }

    return {
      task,
      getStatus,
      getPriority,
      deleteTask
    }
  }
}
</script>
