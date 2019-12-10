<template>
  <v-layout column full-height>
    <v-flex row>
      <v-card>
        <!-- FIXME: auto height -->
        <ag-grid-vue
          style="height: 450px; width: 100vw"
          class="ag-theme-balham"
          :columnDefs="columnDefs"
          :rowData="rowData"
          :modules="modules"
        >
        </ag-grid-vue>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
import "@ag-grid-community/all-modules/dist/styles/ag-grid.css";
import "@ag-grid-community/all-modules/dist/styles/ag-theme-balham.css";

import { AgGridVue } from "@ag-grid-community/vue";
import { AllCommunityModules } from "@ag-grid-community/all-modules";

import users from "../../queries/users";

export default {
  data() {
    return {
      columnDefs: null,
      rowData: null,
      modules: AllCommunityModules
    };
  },
  components: {
    AgGridVue
  },
  beforeMount() {
    users({
      apollo: this.$apollo
    })
      .then(response => {
        return response.data.users;
      })
      .then(result => {
        this.rowData = result;
        let modelKeys = Object.keys(result[0]);

        this.columnDefs = modelKeys.map(k => {
          if (k.includes("__")) return null;
          return {
            headerName: k.toUpperCase(),
            field: k
          };
        }).filter(x => !!x);
      });
  }
};
</script>
