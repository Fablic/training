// Routes users to specific pages depending on the given path
import {createRouter, createWebHistory} from 'vue-router'
import Login from "@/views/Login";
import Home from "@/views/Home";
import Register from "@/views/Register";

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
    path: '/:catchAll(.*)',
    redirect: '/',
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
