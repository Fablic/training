<!--Page that displays all tasks-->
<template>
  <div class="row row-cols-1 row-cols-md-6 g-4 m-3">
    <div class="col">

      <!--New task placeholder-->
      <div class="card h-100 w-100 justify-content-center align-items-center"
           style="cursor: pointer"
           @click="showCreateModal"
      ><i class="bi bi-plus-lg" style="font-size: 4rem"></i>
      </div>
    </div>

    <!--Task grid list-->
    <div class="col" v-for="item in tasks" :key="item.id">
      <Task :task="item" @edit-clicked="showEditModal" @delete-clicked="deleteTask"/>
    </div>
  </div>

  <!--Modal form for task creation-->
  <TaskCreateModal id="taskCreateModal" @create-task="createTask"/>

  <!--Modal form for task edition-->
  <TaskEditModal id="taskEditModal" :target-task="targetTask" @edit-task="editTask"/>

  <!--Toast for notification-->
  <div id="toast" class="toast position-absolute top-0 start-50 translate-middle-x mt-5" role="alert"
       aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
      <strong class="me-auto">Todos</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
    <div class="toast-body" style="font-size: 1rem">
      {{ toastMessage }}
    </div>
  </div>
</template>

<script>
import {inject, onMounted, ref, watch} from "vue";
import axios from "axios";
import Task from "@/components/Task";
import TaskCreateModal from "@/components/TaskCreateModal";
import TaskEditModal from "@/components/TaskEditModal";
import {Modal, Toast} from 'bootstrap';

export default {
  name: "TaskIndex",
  components: {TaskCreateModal, TaskEditModal, Task},
  setup() {
    const store = inject("store")
    const tasks = ref([])
    const toastMessage = ref("")
    let targetTask = ref({})

    onMounted(() => {
      getTasks()
    })

    watch(store.state, () => {
      getTasks()
    })

    function getTasks() {
      let params = {sort: `${store.state.sortBy}:${store.state.sortDir}`}
      if (store.state.statusFilter) {
        params.status = store.state.statusFilter
      }
      if (store.state.search) {
        params.search = store.state.search
      }
      axios.get(process.env.VUE_APP_TASK_SERVICE_BASE_URL + "/tasks", {params}).then(response => {
        tasks.value = response.data
      }).catch(() => {
        triggerToast("Error while fetching tasks!")
      })
    }

    function createTask(task) {
      axios.post(process.env.VUE_APP_TASK_SERVICE_BASE_URL + "/tasks", {task}).then(() => {
        getTasks()
        triggerToast("Task created successfully!")
      }).catch(() => {
        triggerToast("Error while creating task!")
      })
      Modal.getInstance(document.getElementById("taskCreateModal")).hide()
    }

    function editTask(id, editedTask) {
      axios.put(process.env.VUE_APP_TASK_SERVICE_BASE_URL + `/tasks/${id}`, {task: editedTask}).then(() => {
        getTasks()
        triggerToast("Task edited successfully!")
      }).catch((error) => {
        console.log(error)
        triggerToast("Error while editing task!")
      })
      Modal.getInstance(document.getElementById("taskEditModal")).hide()
    }

    function deleteTask(taskId) {
      axios.delete(process.env.VUE_APP_TASK_SERVICE_BASE_URL + `/tasks/${taskId}`).then(() => {
        tasks.value = tasks.value.filter((task) => task.id !== taskId)
        triggerToast("Task deleted successfully!")
      }).catch(() => {
        triggerToast("Error while deleting task!")
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

    function triggerToast(message) {
      let toast = new Toast(document.getElementById("toast"))
      toastMessage.value = message
      toast.show()
    }

    return {
      tasks,
      targetTask,
      toastMessage,
      createTask,
      editTask,
      deleteTask,
      showEditModal,
      showCreateModal
    }
  }
}
</script>
