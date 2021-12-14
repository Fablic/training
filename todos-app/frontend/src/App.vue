<!--Entrypoint to the app-->
<template>
  <p>
    <router-link to="/tasks/index">Index</router-link>
    |
    <router-link to="/task/create">Create Task</router-link>
  </p>
  <router-view/>
</template>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: left;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
