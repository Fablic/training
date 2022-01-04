// Lightweight solution for state management using Composition API
import {reactive} from "vue";

const sortOptions = Object.freeze({"Created": "created_at", "Last Updated": "updated_at", "Due Date": "due_datetime"})
const sortDirOptions = Object.freeze({"Descending": "desc", "Ascending": "asc"})
const statusOptions = Object.freeze({"Not Started": "not_started", "In Progress": "in_progress", "Done": "done"})

const state = reactive({
    sortBy: sortOptions.Created,
    sortDir: sortDirOptions.Descending,
    statusFilter: null,
    search: "",
})

const getters = {
    getCurrentSortKey() {
        return Object.keys(sortOptions).find(key => sortOptions[key] === state.sortBy)
    },

    getCurrentStatusKey() {
        return Object.keys(statusOptions).find(key => statusOptions[key] === state.statusFilter)
    },

    getAuthHeaders() {
        return {Authorization: "Bearer " + localStorage.token}
    }
}

export default {
    state,
    getters
}