<template>
  <nav class="navbar navbar-expand navbar-dark bg-dark">
    <div class="container-fluid justify-content-start">
      <a class="navbar-brand" href="/">Todos</a>
      <div class="navbar-nav">
        <a class="nav-link active" aria-current="page" href="/">Home</a>
      </div>
        <span class="navbar-text ps-5">Welcome {{user.username}}!</span>
    </div>
    <div class="container-fluid justify-content-end col-md-3 col-lg-2 col-xl-2">
      <input class="form-control" type="text" placeholder="Search Title" v-model="store.state.search">
    </div>
    <div class="me-3">
      <button type="button" class="btn btn-outline-light" @click="logout">Logout</button>
    </div>
  </nav>
</template>

<script>
import {inject, onMounted, ref} from "vue";
import {useRouter} from "vue-router";
import axios from "axios";

export default {
  name: "NavBar",
  setup() {
    const router = useRouter()
    const store = inject("store")
    const user = ref({})

    onMounted(() => {
      getUser()
    })

    function getUser() {
      axios.get(process.env.VUE_APP_USER_SERVICE_BASE_URL + "/current-user", {headers: store.getters.getAuthHeaders()}).then(response => {
        user.value = response.data
      }).catch(() => {
        user.value.username = "Unknown"
      })
    }

    function logout() {
      localStorage.removeItem("token")
      router.push("login")
    }

    return {
      store,
      user,
      logout
    }
  }
}
</script>

<style scoped>

</style>
