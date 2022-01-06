<template>
  <nav class="navbar navbar-expand navbar-dark bg-dark">
    <div class="container-fluid justify-content-start">
      <a class="navbar-brand" href="/">Todos</a>
      <div class="navbar-nav">
        <a class="nav-link active" aria-current="page" href="/">Home</a>
        <a v-if="currentUser.role === 'admin'" class="nav-link active" aria-current="page" href="/admin">Admin</a>
      </div>
        <span class="navbar-text ps-5">Welcome {{currentUser.username}}!</span>
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

export default {
  name: "NavBar",
  setup() {
    const router = useRouter()
    const store = inject("store")
    const currentUser = ref({})

    onMounted(() => {
      currentUser.value = JSON.parse(localStorage.getItem("currentUser"))
    })

    function logout() {
      localStorage.removeItem("token")
      localStorage.removeItem(("currentUser"))
      router.push("login")
    }

    return {
      store,
      currentUser,
      logout
    }
  }
}
</script>

<style scoped>

</style>
