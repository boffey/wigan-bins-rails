<template>
    <button 
        class="leading-none block p-1 bg-green-400 text-white hover:bg-green-700 text-sm uppercase rounded-full shadow focus:outline-none focus:shadow-outline"
        @click="openModal"
    >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 fill-current block" viewBox="0 0 24 24"><path class="heroicon-ui" d="M17 11a1 1 0 0 1 0 2h-4v4a1 1 0 0 1-2 0v-4H7a1 1 0 0 1 0-2h4V7a1 1 0 0 1 2 0v4h4z"/></svg>
        <add-location-modal v-if="modalOpen" @close="closeModal" @save="(location) => {this.$emit('save', location)}" />
    </button>
</template>

<script>
import AddLocationModal from "./AddLocationModal";

export default {
  components: { AddLocationModal },
  props: ["open"],
  data() {
    return {
      modalOpen: false
    };
  },
  methods: {
    openModal() {
      this.modalOpen = true;
    },
    closeModal() {
      this.modalOpen = false;
    }
  }
};
</script>
