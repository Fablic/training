// Lightweight solution for state management using Composition API
import {reactive} from "vue";

const sortOptions = Object.freeze({"Created": "created_at", "Last Updated": "updated_at", "Due Date": "due_datetime"})
const sortDirOptions = Object.freeze({"Descending": "desc", "Ascending": "asc"})

const state = reactive({
    sortBy: sortOptions.Created,
    sortDir: sortDirOptions.Descending
})

const getters = {
    getCurrentSortKey() {
        return Object.keys(sortOptions).find(key => sortOptions[key] === state.sortBy)
    }
}

export default {
    state,
    getters
}