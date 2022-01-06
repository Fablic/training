// Lightweight solution for state management using Composition API
import {reactive} from "vue";
import axios from "axios";
import {Toast} from "bootstrap";

const sortOptions = Object.freeze({"Created": "created_at", "Last Updated": "updated_at", "Due Date": "due_datetime"})
const sortDirOptions = Object.freeze({"Descending": "desc", "Ascending": "asc"})
const statusOptions = Object.freeze({"Not Started": "not_started", "In Progress": "in_progress", "Done": "done"})

const state = reactive({
    sortBy: sortOptions.Created,
    sortDir: sortDirOptions.Descending,
    statusFilter: null,
    search: "",
    toastMessage: "",
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

const methods = {
    setCurrentUser() {
        axios.get(process.env.VUE_APP_USER_SERVICE_BASE_URL + "/current-user", {headers: getters.getAuthHeaders()}).then(response => {
            localStorage.currentUser = JSON.stringify(response.data)
        }).catch(() => {
            localStorage.currentUser = {}
        })
    },

    triggerToast(message) {
        let toast = new Toast(document.getElementById("toast"))
        state.toastMessage = message
        toast.show()
    }
}

export default {
    state,
    getters,
    methods,
}