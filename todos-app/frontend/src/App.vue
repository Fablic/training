<!--Entrypoint to the app-->
<template>
  <NavBar/>
  <div class="d-flex justify-content-end">
    <SortMenu/>
    <StatusFilterMenu/>
  </div>
  <router-view/>
</template>
<script>
import NavBar from "@/components/NavBar";
import store from "@/store";
import {provide} from "vue";
import SortMenu from "@/components/SortMenu";
import StatusFilterMenu from "@/components/StatusFilterMenu";

export default {
  components: {StatusFilterMenu, SortMenu, NavBar},
  setup() {
    // provide here so global state store can be accessed in all child components
    provide("store", store)
  }
}
</script>
