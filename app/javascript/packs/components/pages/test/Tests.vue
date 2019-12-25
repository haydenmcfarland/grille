<template>
  <Grid model="tests" v-bind:columns="columns" />
</template>

<script>
import Grid from "../Grid.vue";

export default {
  name: "Tests",
  components: {
    Grid
  },
  data() {
    return {
      columns: ["id", "name", "age", "details"]
    };
  }
};
</script>
