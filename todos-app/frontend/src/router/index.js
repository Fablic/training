// Routes users to specific pages depending on the given path
import {createRouter, createWebHistory} from 'vue-router'
import Login from "@/views/Login";
import Home from "@/views/Home";
import Register from "@/views/Register";
import Admin from "@/views/Admin";
import store from "@/store";

const routes = [
  {
    path: '/',
    name: "Home",
    component: Home
  },
  {
    path: '/login',
    name: "Login",
    component: Login
  },
  {
    path: '/register',
    name: "Register",
    component: Register
  },
  {
    path: '/admin',
    name: "Admin",
    component: Admin,
    beforeEnter: (to, from, next) => {
      if (localStorage.currentUser && JSON.parse(localStorage.currentUser).role === 'admin') {
        next()
      } else {
        store.methods.triggerToast("Only for admins!")
        next("/")
      }
    }
  },
  {
    path: '/:catchAll(.*)',
    redirect: '/',
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
