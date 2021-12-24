<template>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid justify-content-start">
      <a class="navbar-brand" href="/">Todos</a>
      <div class="navbar-nav">
        <a class="nav-link active" aria-current="page" href="/">Home</a>
      </div>
    </div>
    <div class="container-fluid justify-content-end col-2">
      <input class="form-control" type="text" placeholder="Search Title" v-model="store.state.search">
    </div>
  </nav>
</template>

<script>
import {inject} from "vue";

export default {
  name: "NavBar",
  setup() {
    const store = inject("store")

    return {
      store
    }
  }
}
</script>

<style scoped>

</style>
