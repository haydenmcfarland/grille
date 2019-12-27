<template>
  <Grid model="tests" v-bind:columns="columns" v-bind:pageSize="pageSize" />
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
      columns: ["id", "name", "age", "details"],
      pageSize: 3
    };
  }
};
</script>
