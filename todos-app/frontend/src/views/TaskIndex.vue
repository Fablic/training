<!--Page that displays all tasks-->
<template>
  <h1 v-if="store.state.search" class="display-6 ms-5">Showing results for "{{store.state.search}}"</h1>
  <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 row-cols-xl-5 g-4 m-3">
    <div class="col">

      <!--New task placeholder-->
      <div class="card h-100 w-100 justify-content-center align-items-center"
           style="cursor: pointer; min-height: 310px"
           @click="showCreateModal"
      ><i class="bi bi-plus-lg" style="font-size: 4rem"></i>
      </div>
    </div>

    <!--Task grid list-->
    <div class="col" v-for="item in tasks" :key="item.id">
      <Task :enable-edit="true" :task="item" @edit-clicked="showEditModal" @delete-clicked="deleteTask"/>
    </div>
  </div>

  <!--Modal form for task creation-->
  <TaskCreateModal id="taskCreateModal" @create-task="createTask"/>

  <!--Modal form for task edition-->
  <TaskEditModal id="taskEditModal" :target-task="targetTask" @edit-task="editTask"/>
</template>

<script>
import {inject, onMounted, ref, watch} from "vue";
import axios from "axios";
import Task from "@/components/Task";
import TaskCreateModal from "@/components/TaskCreateModal";
import TaskEditModal from "@/components/TaskEditModal";
import {Modal} from 'bootstrap';
import {useRouter} from "vue-router";

export default {
  name: "TaskIndex",
  components: {TaskCreateModal, TaskEditModal, Task},
  setup() {
    const router = useRouter()
    const store = inject("store")
    const tasks = ref([])
    let targetTask = ref({})
    const MAX_FETCH_COUNT = 20
    let currentOffset = 0
    let didReachEnd = false

    onMounted(() => {
      resetPage()
    })

    // watch for changes in sort / filter
    watch(() => [store.state.search, store.state.statusFilter, store.state.sortBy, store.state.sortDir], () => {
      resetPage()
    })

    function resetPage() {
      currentOffset = 0
      tasks.value = []
      didReachEnd = false
      getTasks()
    }

    function getTasks() {
      let params = {
        sort: `${store.state.sortBy}:${store.state.sortDir}`,
        offset: currentOffset,
        limit: MAX_FETCH_COUNT
      }
      if (store.state.statusFilter) {
        params.status = store.state.statusFilter
      }
      if (store.state.search) {
        params.search = store.state.search
      }
      axios.get(process.env.VUE_APP_TASK_SERVICE_BASE_URL + "/tasks", {params, headers: store.getters.getAuthHeaders()}).then(response => {
        tasks.value.push(...response.data.tasks)
        // checking if there's more to load
        didReachEnd = response.data.tasks.length < MAX_FETCH_COUNT
      }).catch((error) => {
        if (error.response.status === 401) router.push("login")
        store.methods.triggerToast("Error while fetching tasks!")
      })
    }

    function createTask(task) {
      axios.post(process.env.VUE_APP_TASK_SERVICE_BASE_URL + "/tasks", {task}, {headers: store.getters.getAuthHeaders()}).then(() => {
        resetPage()
        store.methods.triggerToast("Task created successfully!")
      }).catch((error) => {
        if (error.response.status === 401) router.push("login")
        store.methods.triggerToast("Error while creating task!")
      })
      Modal.getInstance(document.getElementById("taskCreateModal")).hide()
    }

    function editTask(id, editedTask) {
      axios.put(process.env.VUE_APP_TASK_SERVICE_BASE_URL + `/tasks/${id}`, {task: editedTask}, {headers: store.getters.getAuthHeaders()}).then((response) => {
        tasks.value[tasks.value.findIndex(el => el.id === response.data.id)] = response.data
        store.methods.triggerToast("Task edited successfully!")
      }).catch((error) => {
        console.log(error)
        store.methods.triggerToast("Error while editing task!")
      })
      Modal.getInstance(document.getElementById("taskEditModal")).hide()
    }

    function deleteTask(taskId) {
      axios.delete(process.env.VUE_APP_TASK_SERVICE_BASE_URL + `/tasks/${taskId}`, {headers: store.getters.getAuthHeaders()}).then(() => {
        tasks.value = tasks.value.filter((task) => task.id !== taskId)
        store.methods.triggerToast("Task deleted successfully!")
      }).catch(() => {
        store.methods.triggerToast("Error while deleting task!")
      })
    }

    function showEditModal(task) {
      targetTask.value = task
      Modal.getOrCreateInstance(document.getElementById("taskEditModal")).show()
    }

    function showCreateModal() {
      let modal = new Modal(document.getElementById("taskCreateModal"))
      modal.show()
    }

    // handle infinite scrolling
    window.onscroll = () => {
      if (!didReachEnd && document.documentElement.scrollTop + window.innerHeight === document.documentElement.offsetHeight) {
        currentOffset += MAX_FETCH_COUNT
        getTasks()
      }
    }

    return {
      store,
      tasks,
      targetTask,
      createTask,
      editTask,
      deleteTask,
      showEditModal,
      showCreateModal
    }
  }
}
</script>
