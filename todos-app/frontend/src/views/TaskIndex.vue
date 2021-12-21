<!--Page that displays all tasks-->
<template>
  <div>
    <ul>
      <li v-for="task in tasks" :key="task.id">
        {{ task.title }}
        <br>
        <button @click="$router.push({name: 'TaskDetail', params: { id: task.id }})">Detail</button>
        <button @click="$router.push({name: 'TaskEdit', params: {id: task.id }})">Edit</button>
        <button @click="deleteTask(task.id)">Delete</button>
      </li>
    </ul>
  </div>
</template>

<script>
import {onMounted, ref} from "vue";
import axios from "axios";

export default {
  name: "TaskIndex",
  setup() {
    const tasks = ref([])

    onMounted(() => {
      axios.get(process.env.VUE_APP_TASK_SERVICE_BASE_URL + "/tasks").then(response => {
        tasks.value = response.data
      }).catch(() => {
        alert("Error while fetching tasks!")
      })
    })

    function deleteTask(id) {
      axios.delete(process.env.VUE_APP_TASK_SERVICE_BASE_URL + `/tasks/${id}`).then(() => {
        tasks.value = tasks.value.filter(task => task.id !== id)
        alert("Task deleted successfully!")
      }).catch(() => {
        alert("Error while deleting task!")
      })
    }

    return {
      tasks,
      deleteTask
    }
  }
}
</script>
