<!--Entrypoint to the app-->
<template>
  <NavBar/>
  <router-view/>
</template>
<script>
import NavBar from "@/components/NavBar";
export default {
  components: {NavBar}
}
</script>