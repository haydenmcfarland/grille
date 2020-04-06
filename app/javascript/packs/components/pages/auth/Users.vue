<template>
  <Grid model="users" v-bind:columns="columns" />
</template>

<script>
import Grid from "../Grid.vue.erb";

export default {
  name: "Users",
  components: {
    Grid
  },
  data() {
    return {
      columns: ["id", "email", "firstName"]
    };
  }
};
</script>
