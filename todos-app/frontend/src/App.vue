<!--Entrypoint to the app-->
<template>
  <NavBar/>
  <SortMenu/>
  <router-view/>
</template>
<script>
import NavBar from "@/components/NavBar";
import store from "@/store";
import {provide} from "vue";
import SortMenu from "@/components/SortMenu";

export default {
  components: {SortMenu, NavBar},
  setup() {
    // provide here so global state store can be accessed in all child components
    provide("store", store)
  }
}
</script>
