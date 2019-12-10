<template>
  <v-layout column full-height>
    <v-flex row style="margin: 50px">
      <v-card>
        <!-- FIXME: auto height -->
        <ag-grid-vue
          style="height: 200px; width: 75vw"
          class="ag-theme-balham"
          :columnDefs="columnDefs"
          :rowData="rowData"
          :modules="modules"
          rowSelection="multiple"
          @grid-ready="onGridReady"
        >
        </ag-grid-vue>
        <v-toolbar>
          <v-toolbar-items>
            <v-btn text @click="getSelectedRows()">
              <v-icon left>mdi-delete</v-icon> Delete
            </v-btn>

            <v-divider inset vertical></v-divider>

            <v-btn text @click="getSelectedRows()">
              <v-icon left>mdi-pencil</v-icon> Edit
            </v-btn>
          </v-toolbar-items>
        </v-toolbar>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
import "@ag-grid-community/all-modules/dist/styles/ag-grid.css";
import "@ag-grid-community/all-modules/dist/styles/ag-theme-balham.css";

import { AgGridVue } from "@ag-grid-community/vue";
import { AllCommunityModules } from "@ag-grid-community/all-modules";

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
  props: {
    model: {
      type: String,
      default: "users"
    }
  },
  methods: {
    onGridReady(params) {
      this.gridApi = params.api;
      this.columnApi = params.columnApi;
    },
    getSelectedRows() {
      const selectedNodes = this.gridApi.getSelectedNodes();
      const selectedData = selectedNodes.map(node => node.data);
      const selectedDataStringPresentation = JSON.stringify(selectedData);
      alert(`Selected nodes: ${selectedDataStringPresentation}`);
    }
  },
  beforeMount() {
    const defaultColumnConfig = {
      sortable: true,
      filter: true
    };

    import(`../../queries/${this.model}`)
      .then(m => {
        return m.default({ apollo: this.$apollo });
      })
      .then(response => {
        // FIXME: pluralize model instead of declaring model
        // pluralized
        return response.data[this.model];
      })
      .then(result => {
        this.rowData = result;

        // FIXME: better introspection
        // protect via roles and add column configs
        let modelKeys = Object.keys(result[0]);

        this.columnDefs = modelKeys
          .map(k => {
            if (k.includes("__")) return null;
            return {
              ...defaultColumnConfig,
              ...{
                headerName: k.toUpperCase(),
                field: k
              }
            };
          })
          .filter(x => !!x);
      });
  }
};
</script>

<style scoped>
a {
  text-decoration: none;
}
.v-btn:hover:before {
  background-color: transparent;
}
</style>
