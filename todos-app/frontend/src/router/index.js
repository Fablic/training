// Routes users to specific pages depending on the given path
import {createRouter, createWebHistory} from 'vue-router'
import TaskIndex from "@/views/TaskIndex";
import TaskDetail from "@/views/TaskDetail";
import TaskCreate from "@/views/TaskCreate";
import TaskEdit from "@/views/TaskEdit";

const routes = [
  {
    path: '/tasks/index',
    name: "TaskIndex",
    component: TaskIndex
  },
  {
    path: '/task/create',
    name: "TaskCreate",
    component: TaskCreate
  },
  {
    path: '/tasks/:id',
    name: 'TaskDetail',
    component: TaskDetail
  },
  {
    path: '/tasks/:id/edit',
    name: 'TaskEdit',
    component: TaskEdit
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
