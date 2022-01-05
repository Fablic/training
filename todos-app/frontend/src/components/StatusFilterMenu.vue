<template>
  <div class="d-flex align-items-center my-3 me-3">
    <label class="text-black mx-3">Filter By</label>
    <div class="dropdown">
      <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="sortDropdown" data-bs-toggle="dropdown">{{ store.getters.getCurrentStatusKey() || "Status" }}</button>
      <ul class="dropdown-menu">
        <li><a class="dropdown-item" @click="store.state.statusFilter = 'not_started'">Not Started<i v-if="store.state.statusFilter === 'not_started'" class="bi bi-check"></i></a></li>
        <li><a class="dropdown-item" @click="store.state.statusFilter = 'in_progress'">In Progress<i v-if="store.state === 'in_progress'" class="bi bi-check"></i></a></li>
        <li><a class="dropdown-item" @click="store.state.statusFilter = 'done'">Done<i v-if="store.state.statusFilter === 'done'" class="bi bi-check"></i></a></li>
      </ul>
    </div>
    <i v-if="store.state.statusFilter" class="bi bi-x-circle-fill mx-2" @click="store.state.statusFilter = null"></i>
  </div>
</template>

<script>
import {inject} from "vue";

export default {
  name: "StatusFilterMenu",
  setup() {
    const store = inject("store")

    return {
      store
    }
  }
}
</script>

<style scoped>
i.bi-check {
  color: green;
}

i.bi-x-circle-fill {
  cursor: pointer;
}
</style>
