<!--Entrypoint to the app-->
<template>
  <router-view/>
</template>
<script>
import store from "@/store";
import {provide} from "vue";

export default {
  setup() {
    // provide here so global state store can be accessed in all child components
    provide("store", store)
  }
}
</script>
