// Routes users to specific pages depending on the given path
import {createRouter, createWebHistory} from 'vue-router'
import TaskIndex from "@/views/TaskIndex";

const routes = [
  {
    path: '/tasks/index',
    name: "TaskIndex",
    component: TaskIndex
  },
  {
    path: '/:catchAll(.*)',
    redirect: '/tasks/index',
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
