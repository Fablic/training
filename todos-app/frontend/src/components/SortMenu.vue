<template>
  <div class="d-flex align-items-center my-3 me-3">
    <label class="text-black mx-3">Sort By</label>
    <div class="dropdown">
      <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="sortDropdown"
              data-bs-toggle="dropdown">{{ store.getters.getCurrentSortKey() }}
      </button>
      <ul class="dropdown-menu" aria-labelledby="sortDropdown">
        <li><a class="dropdown-item" @click="store.state.sortBy = 'created_at'">Created Date<i
            v-if="store.state.sortBy === 'created_at'" class="bi bi-check"></i></a></li>
        <li><a class="dropdown-item" @click="store.state.sortBy = 'updated_at'">Last Updated<i
            v-if="store.state.sortBy === 'updated_at'" class="bi bi-check"></i></a></li>
        <li><a class="dropdown-item" @click="store.state.sortBy = 'due_datetime'">Due Date<i
            v-if="store.state.sortBy === 'due_datetime'" class="bi bi-check"></i></a></li>
        <li>
          <hr class="dropdown-divider">
        </li>
        <li><a class="dropdown-item" @click="store.state.sortDir = 'desc'">Descending <i
            v-if="store.state.sortDir === 'desc'" class="bi bi-check"></i></a></li>
        <li><a class="dropdown-item" @click="store.state.sortDir = 'asc'">Ascending <i
            v-if="store.state.sortDir === 'asc'" class="bi bi-check"></i></a></li>
      </ul>
    </div>
  </div>
</template>

<script>
import {inject} from "vue";

export default {
  name: "SortMenu",
  setup() {
    const store = inject("store")

    return {
      store
    }
  }
}
</script>

<style scoped>
i {
  color: green;
}
</style>