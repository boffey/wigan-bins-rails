<template>
    <portal to="modals">
        <div class="fixed inset-0 z-50 overflow-auto flex bg-modal-backdrop">
            <div class="w-full max-w-lg m-auto ">
                <div class="p-8 bg-white rounded shadow-lg m-4 relative">
                    <button class="absolute top-0 right-0 py-2 px-2 mt-2 mr-2 text-gray-700" @click="closeModal">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="h-8 w-8 fill-current"><path class="heroicon-ui" d="M16.24 14.83a1 1 0 0 1-1.41 1.41L12 13.41l-2.83 2.83a1 1 0 0 1-1.41-1.41L10.59 12 7.76 9.17a1 1 0 0 1 1.41-1.41L12 10.59l2.83-2.83a1 1 0 0 1 1.41 1.41L13.41 12l2.83 2.83z"/></svg>
                    </button>

                    <h1 class="font-semibold text-2xl text-grey-900 mb-2">Add Location</h1>
                    <p class="leading-normal text-sm text-grey-700 mb-4">To add a new location enter your postcode below, select your address and give it a name and we will fetch this weeks collections for you.</p>
                    <form @submit.prevent="save">
                        <div class="mb-4">
                            <label class="block text-sm mb-2 text-grey-700 font-semibold">Postcode</label>
                            <div class="flex">
                                <div class="relative flex-1">
                                    <input type="text" v-model="postcode" ref="postcode" class="w-full appearance-none bg-grey-lightest rounded px-4 py-3 text-gray-700 border border-gray-200 outline-none focus:shadow-outline" @keydown.enter="search" autofocus placeholder="e.g. WN3 4AL">
                                    <loader class="block absolute h-2 right-0 inset-y-0 my-auto mr-4" v-if="loading" />
                                </div>
                                <button @click="search" type="button" class="appearance-none text-sm ml-2 px-4 py-3 bg-green-500 leading-none rounded text-white hover:bg-green-600 font-semibold shadow focus:outline-none focus:shadow-outline">Search</button>
                            </div>
                        </div>
                        <div :class="{'opacity-25': disabledForm}">
                            <div class="mb-4">
                                <label class="block text-sm mb-2 text-gray-700 font-semibold">Select Property</label>
                                <select :disabled="disabledForm" v-model="propertyId" class="appearance-none w-full bg-grey-lightest rounded px-4 py-3 text-gray-700 border border-gray-200 outline-none focus:shadow-outline">
                                    <option value="">Please Select...</option>
                                    <option :value="property.id" :key="property.id" v-for="property in properties">{{ property.value }}</option>
                                </select>
                            </div>
                            <div class="mb-4">
                                <label class="block text-sm mb-2 text-gray-700 font-semibold">Name</label>
                                <input :disabled="disabledForm" v-model="name" type="text" class="w-full appearance-none bg-grey-lightest rounded px-4 py-3 text-gray-700 border border-gray-200 outline-none focus:shadow-outline" placeholder="Home">
                            </div>
                            <div>
                                <button :disabled="disabledForm" class="block w-full bg-green-500 rounded shadow text-white py-3 font-semibold focus:outline-none focus:shadow-outline">Save</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </portal>
</template>

<script>
import axios from "axios";
import Loader from "./Icons/Loader";

export default {
  components: { Loader },
  data() {
    return {
      postcode: "",
      propertyId: "",
      name: "",
      properties: [],
      loading: false
    };
  },
  created() {
    const escapeHandler = e => {
      if (e.key === "Escape") {
        this.closeModal();
      }
    };

    document.addEventListener("keydown", escapeHandler);
    document.body.style.setProperty("overflow", "hidden");

    this.$once("hook:destroyed", () => {
      document.removeEventListener("keydown", escapeHandler);
      document.body.style.removeProperty("overflow");
    });
  },
  mounted() {
    this.$nextTick(() => {
      this.$refs.postcode.focus();
    });
  },
  computed: {
    disabledForm() {
      return this.properties.length === 0;
    }
  },
  methods: {
    async search() {
      this.loading = true;
      const { data: properties } = await axios.get(
        `/properties.json?q=${this.postcode}`
      );
      this.properties = properties;
      this.loading = false;
    },
    save() {
      this.$emit("save", {
        id: this.propertyId,
        name: this.name
      });
      this.$emit("close");
    },
    closeModal() {
      this.$emit("close");
    }
  }
};
</script>
