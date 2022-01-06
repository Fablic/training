<!--Entrypoint to the app-->
<template>
  <router-view/>
  <!--Toast for notification-->
  <div id="toast" class="toast position-absolute top-0 start-50 translate-middle-x mt-5" role="alert"
       aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
      <strong class="me-auto">Todos</strong>
      <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
    <div class="toast-body" style="font-size: 1rem">
      {{ store.state.toastMessage }}
    </div>
  </div>
</template>
<script>
import store from "@/store";
import {provide} from "vue";

export default {
  setup() {
    // provide here so global state store can be accessed in all child components
    provide("store", store)

    return {
      store
    }
  }
}
</script>
