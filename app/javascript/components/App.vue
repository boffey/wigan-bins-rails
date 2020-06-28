<template>
  <div>
    <div class="mx-auto max-w-lg bg-white rounded-lg p-6 my-8 shadow-lg">
      <div class="flex justify-between items-center mb-6">
        <h1 class="font-light text-center text-gray-700 text-2xl capitalize font-semibold m-0">
          Wigan Bin Checker
        </h1>
        <add-location-button @save="addLocation" />
      </div>
      <location 
        :key="location.id"
        :location="location"
        v-for="location in locations"
        @delete="deleteLocation"
      ></location>
    </div>

    <div class="text-center">
      <p class="text-center text-gray-500 text-sm no-underline">Wigan Bins</p>
    </div>

    <portal-target name="modals"></portal-target>
  </div>
</template>

<script>
import axios from "axios";
import Location from "./Location";
import AddLocationButton from "./AddLocationButton";

export default {
  name: "app",
  components: { Location, AddLocationButton },
  data() {
    return {
      showAddForm: false,
      locations: []
    };
  },
  created() {
    const locations = localStorage.getItem("locations");
    if (locations) {
      this.locations = JSON.parse(locations).map(location => {
        location.collections = this.getCollections(location);
        return location;
      });
    }
  },
  methods: {
    toggleAddForm() {
      this.showAddForm = !this.showAddForm;
    },
    async addLocation(location) {
      location = await this.getCollections(location);
      this.locations = [...this.locations, location];
      localStorage.setItem("locations", JSON.stringify(this.locations));
    },
    deleteLocation(location) {
      this.locations = this.locations.filter(l => l.id !== location.id);
      localStorage.setItem("locations", JSON.stringify(this.locations));
    },
    async getCollections(location) {
      const { id: propertyId } = location;
      const { data: collections } = await axios.get(
        `/properties/${propertyId}/collections.json`
      );
      location.collections = collections;

      return location;
    }
  }
};
</script>
