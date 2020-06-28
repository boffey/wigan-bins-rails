<template>
    <div class="mb-8">
        <div class="flex justify-between items-center mb-3">
            <h2 class="font-semibold text-base capitalize text-gray-700 m-0">{{ location.name }} <span class="text-gray-600 text-xs font-light">- Collections</span></h2>
            <button
                class="text-xs text-gray-700 capitalize bg-gray-100 px-2 py-1 rounded text-red-light hover:bg-gray-300 focus:outline-none focus:shadow-outline"
                @click="handleDelete(location)"
            >
                Delete
            </button>
        </div>
        
        <div class="flex justify-center bg-gray-lightest py-3 mb-2 rounded" v-show="Object.keys(location.collections).length === 0">
            <loader class="h-3" />
        </div>

        <ul class="list-reset text-sm text-gray-900 rounded" v-show="Object.keys(location.collections).length > 0">
            <li
                class="flex justify-between mb-2 bg-gray-100 rounded px-4 py-3"
                :key="index"
                v-for="(collection, index) in location.collections"
            >
                <span class="font-semibold">{{ collection.name }}</span> <span>{{ collection.date | date }}</span>
            </li>
        </ul>
    </div>
</template>

<script>
import Loader from "./Icons/Loader";
import { format, parseISO } from "date-fns";

export default {
  components: { Loader },
  props: ["location"],
  filters: {
    date(date) {
      return format(parseISO(date), "EEEE do");
    }
  },
  methods: {
    handleDelete(location) {
      this.$emit("delete", location);
    }
  }
};
</script>
