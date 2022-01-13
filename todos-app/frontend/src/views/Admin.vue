<template>
  <NavBar/>
  <div class="container-fluid my-4">
    <table class="table table-striped table-hover table-responsive">
      <thead>
      <tr>
        <th>Email</th>
        <th>Username</th>
        <th style="width: 10%">Role</th>
        <th>No. of Tasks</th>
        <th style="width: 5%">Control</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="(user, i) in users" :key="i">
        <td>{{ user.email }}</td>
        <td>{{ user.username }}</td>
        <td>
          <select class="form-select-sm" v-model="user.role" @change="editUser(user)" :disabled="isCurrentUser(user.id)">
            <option value="admin">admin</option>
            <option value="user">user</option>
          </select>
        </td>
        <td>{{ user.task_count }}</td>
        <td>
          <i data-bs-toggle="modal" data-bs-target="#userTaskModal"
             @click="targetUserTasks=userTasks.filter((userTask) => userTask.user_id === user.id)[0]" type="button"
             class="bi bi-eye me-3"/>
          <i @click="deleteUser(user.id)" type="button" class="bi bi-trash"/>
        </td>
      </tr>
      </tbody>
    </table>
  </div>

  <!--Modal for displaying user tasks-->
  <div id="userTaskModal" class="modal fade" tabindex="-1">
    <div class="modal-dialog modal-dialog-scrollable modal-fullscreen">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Task list</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 row-cols-xl-5 g-4 m-3">
            <div class="col" v-for="item in targetUserTasks.tasks" :key="item.id">
              <Task :enable-edit="false" :task="item"/>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

import {inject, onMounted, ref} from "vue";
import axios from "axios";
import {useRouter} from "vue-router";
import NavBar from "@/components/NavBar";
import Task from "@/components/Task";

export default {
  name: "Admin",
  components: {Task, NavBar},
  setup() {
    const store = inject("store")
    const router = useRouter()
    const users = ref([])
    const userTasks = ref([])
    const targetUserTasks = ref([])
    const currentPage = ref(1)

    onMounted(() => {
      axios.get(process.env.VUE_APP_USER_SERVICE_BASE_URL + "/users", {headers: store.getters.getAuthHeaders()}).then(response => {
        users.value = response.data
        // get task count for each user
        users.value.forEach((user) => {
          axios.get(process.env.VUE_APP_TASK_SERVICE_BASE_URL + "/tasks", {
            params: {user_id: user.id, limit: 50},
            headers: store.getters.getAuthHeaders()
          }).then(response => {
            userTasks.value.push({user_id: user.id, tasks: response.data.tasks})
            users.value[users.value.findIndex(el => el.id === user.id)].task_count = response.data.total_count
          })
        })
      }).catch((e) => {
        store.methods.triggerToast("Error while fetching users")
        if (e.response.status === 401) router.push("/login")
      })
    })

    function editUser(user) {
      axios.put(process.env.VUE_APP_USER_SERVICE_BASE_URL + `/users/${user.id}`, {user}, {headers: store.getters.getAuthHeaders()}).then(() => {
        store.methods.triggerToast("User edited successfully!")
      }).catch(() => {
        store.methods.triggerToast("You cannot edit yourself!")
      })
    }

    function deleteUser(userId) {
      // delete target user
      axios.delete(process.env.VUE_APP_USER_SERVICE_BASE_URL + `/users/${userId}`, {headers: store.getters.getAuthHeaders()}).then(() => {
        users.value = users.value.filter((user) => user.id !== userId)
        // delete all tasks owned by the user
        axios.delete(process.env.VUE_APP_TASK_SERVICE_BASE_URL + `/tasks`, {
          params: {user_id: userId},
          headers: store.getters.getAuthHeaders()
        }).then(() => {
          store.methods.triggerToast("User deleted successfully!")
        })
      }).catch(() => {
        store.methods.triggerToast("You cannot delete an admin user!")
      })
    }

    function isCurrentUser(id) {
      return JSON.parse(localStorage.currentUser).id === id
    }

    return {
      users,
      userTasks,
      targetUserTasks,
      currentPage,
      editUser,
      deleteUser,
      isCurrentUser
    }
  }
}
</script>
