<template>
  <NavBar/>
  <div class="d-flex justify-content-end">
    <SortMenu/>
    <StatusFilterMenu/>
  </div>
  <TaskIndex/>
</template>

<script>
import NavBar from "@/components/NavBar";
import SortMenu from "@/components/SortMenu";
import StatusFilterMenu from "@/components/StatusFilterMenu";
import TaskIndex from "@/views/TaskIndex";
export default {
  name: "Home",
  components: {TaskIndex, StatusFilterMenu, SortMenu, NavBar}
}
</script>

<style scoped>

</style>