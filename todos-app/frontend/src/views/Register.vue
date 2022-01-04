<template>
  <div class="d-flex min-vh-100 align-items-center justify-content-center">
    <div class="card" style="width: 25rem">
      <div class="card-body">
        <h4 class="card-title text-center mb-4 mt-1">Create an account</h4>
        <hr>
        <form @submit.prevent="register">
          <div class="input-group mb-3">
            <span class="input-group-text"> <i class="bi bi-envelope-fill"></i> </span>
            <input name="email" class="form-control" placeholder="Email" type="email" required>
          </div>
          <div class="input-group mb-3">
            <span class="input-group-text"> <i class="bi bi-person-fill"></i> </span>
            <input name="username" class="form-control" placeholder="Username" type="text" required>
          </div>
          <div class="input-group mb-3">
            <span class="input-group-text"> <i class="bi bi-lock-fill"></i> </span>
            <input name="password" class="form-control" placeholder="Password" type="password" required>
          </div>
          <div class="input-group mb-4">
            <span class="input-group-text"> <i class="bi bi-lock-fill"></i> </span>
            <input name="password-confirm" class="form-control" placeholder="Password Confirm" type="password" required>
          </div>
          <h6 v-if="registerFailed" class="text-danger text-center mb-3">Register failed. Please try again.</h6>
          <div class="mb-3">
            <button type="submit" class="btn btn-primary w-100">Register</button>
          </div>
          <div class="text-center">
            <a href="/login">Login</a>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import {ref} from "vue";
import axios from "axios";
import {useRouter} from "vue-router";

export default {
  name: "Register",
  setup() {
    const router = useRouter()
    const registerFailed = ref(false)

    function register(event) {
      const user = {
        email: event.target.email.value,
        username: event.target.username.value,
        password: event.target.password.value,
        password_confirmation: event.target["password-confirm"].value
      }
      axios.post(process.env.VUE_APP_USER_SERVICE_BASE_URL + "/users", {user}).then((response) => {
        localStorage.token = response.data.token
        router.push("Home")
      }).catch(() => {
        registerFailed.value = true
      })
    }
    return {
      registerFailed,
      register
    }
  }
}
</script>

<style scoped>

</style>