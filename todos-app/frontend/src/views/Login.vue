<template>
  <div class="d-flex min-vh-100 align-items-center justify-content-center">
    <div class="card" style="width: 25rem">
      <div class="card-body">
        <h4 class="card-title text-center mb-4 mt-1">Sign in</h4>
        <hr>
        <form @submit.prevent="login">
          <div class="input-group mb-3">
            <span class="input-group-text"> <i class="bi bi-envelope-fill"></i> </span>
            <input name="email" class="form-control" placeholder="Email" type="email" required>
          </div>
          <div class="input-group mb-4">
            <span class="input-group-text"> <i class="bi bi-lock-fill"></i> </span>
            <input name="password" class="form-control" placeholder="Password" type="password" required>
          </div>
          <h6 v-if="loginFailed" class="text-danger text-center mb-3">Login failed. Please try again.</h6>
          <div class="mb-3">
            <button type="submit" class="btn btn-primary w-100">Login</button>
          </div>
          <div class="text-center">
            <a href="/register">Sign up</a>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import {ref} from "vue";
import {useRouter} from "vue-router";

export default {
  name: "Login",
  setup() {
    const router = useRouter()
    const loginFailed = ref(false)

    function login(event) {
      const auth = {
        email: event.target.email.value,
        password: event.target.password.value
      }
      axios.post(process.env.VUE_APP_USER_SERVICE_BASE_URL + "/login", {auth}).then((response) => {
        localStorage.token = response.data.token
        localStorage.currentUser = JSON.stringify(response.data.user)
        router.push("Home")
      }).catch(() => {
        loginFailed.value = true
      })
    }

    return {
      loginFailed,
      login
    }
  }
}
</script>

<style scoped>

</style>