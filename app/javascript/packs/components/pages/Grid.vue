<template>
  <v-layout>
    <v-flex>
      <v-card>
        <ag-grid-vue
          style="width: 100%;"
          class="ag-theme-balham grille-grid"
          :columnDefs="columnDefs"
          :rowData="rowData"
          :modules="modules"
          rowSelection="multiple"
          @filter-changed="onFilterChanged"
          @sort-changed="onSortChanged"
          @grid-ready="onGridReady"
          @cell-value-changed="onCellEdit"
        >
        </ag-grid-vue>
        <Confirm ref="confirm"></Confirm>
        <v-toolbar>
          <v-toolbar-items>
            <v-btn text @click="refreshPage()">
              <v-icon>mdi-refresh</v-icon>
            </v-btn>

            <v-pagination
              v-model="pageNumber"
              class="my-4"
              :length="totalPages"
              :total-visible="5"
              @input="loadData"
            ></v-pagination>

            <v-divider inset vertical></v-divider>

            <!-- FIXME: generalize these into 'actions' -->
            <v-btn text @click="handleModelDelete()">
              <v-icon left>mdi-delete</v-icon> Delete
            </v-btn>

            <v-divider inset vertical></v-divider>

            <v-btn text @click="addNewRow()">
              <v-icon left>mdi-plus</v-icon> Add
            </v-btn>

            <v-btn text @click="applyChanges()">
              <v-icon left>mdi-check</v-icon> Apply
            </v-btn>

            <v-divider inset vertical></v-divider>

            <v-btn text @click="getSelectedRows()">
              <v-icon left>mdi-table</v-icon> Export
            </v-btn>
          </v-toolbar-items>
        </v-toolbar>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
// FIXME: make themes that work with dark mode
import "@ag-grid-community/all-modules/dist/styles/ag-grid.css";
import "@ag-grid-community/all-modules/dist/styles/ag-theme-balham.css";

import { AgGridVue } from "@ag-grid-community/vue";
import { AllCommunityModules } from "@ag-grid-community/all-modules";

import Confirm from "../Confirm";

// grid mutations
// FIXME: use camel for file names
import modelDelete from "../../mutations/modelDelete";
import modelUpdate from "../../mutations/modelUpdate";
import modelRecords from "../../queries/modelRecords";

// state management
import { mapMutations } from "vuex";

// color mapping
const actionColorMap = {
  delete: "red",
  apply: "green"
};

// FIXME: handle grid refresh & DRY
export default {
  data() {
    return {
      columnDefs: null,
      rowData: null,
      modules: AllCommunityModules,
      pageNumber: 1,
      totalPages: 1
    };
  },
  components: {
    AgGridVue,
    Confirm
  },
  props: {
    model: {
      type: String,
      default: "users"
    },
    pageSize: {
      type: Number,
      default: 10
    },
    columns: {
      type: Array,
      default: () => ["id"]
    }
  },
  methods: {
    ...mapMutations(["modelDelete"]),
    onGridReady(params) {
      this.gridApi = params.api;
      this.columnApi = params.columnApi;
    },
    onFilterChanged(_event) {
      this.refreshPage();
    },
    onSortChanged(_event) {
      this.refreshPage()
    },
    onCellEdit(item) {
      // FIXME: this is a very basic implementation
      item.node.newOrModified = true;
    },
    getSelectedRows() {
      const selectedNodes = this.gridApi.getSelectedNodes();
      const selectedData = selectedNodes.map(node => node.data);
      const selectedDataStringPresentation = JSON.stringify(selectedData);
      alert(`Selected nodes: ${selectedDataStringPresentation}`);
    },
    addNewRow(params) {
      this.gridApi.updateRowData({ add: [{ newOrModified: true }] });
    },
    refreshPage() {
      this.loadData(this.pageNumber, rowData => {
        this.gridApi.setRowData(rowData);
      });
    },
    confirmAction(action, callback) {
      this.$refs.confirm
        .open(action, "Are you sure?", {
          color: actionColorMap[action] || "green"
        })
        .then(confirm => {
          if (!confirm) return;
          callback();
        });
    },
    applyChanges(params) {
      let rowData = [];
      this.gridApi.forEachNode(node => {
        if (node.newOrModified) rowData.push(JSON.stringify(node.data));
      });

      // FIXME: generalize for CRUD
      this.confirmAction("apply", () => {
        modelUpdate({
          apollo: this.$apollo,
          ...{ model: this.model, jsonArray: rowData }
        }).then(response => {
          if (response.data.update.result === true) this.refreshPage();
        });
      });
    },
    handleModelDelete() {
      let selectedNodes = this.gridApi.getSelectedNodes();
      let ids = selectedNodes.map(node => node.data.id);

      this.confirmAction("delete", () => {
        modelDelete({
          apollo: this.$apollo,
          ...{ model: this.model, ids: ids }
        }).then(response => {
          if (response.data.delete.result === true) this.refreshPage();
        });
      });
    },
    loadData(page, callback = null) {
      // FIXME: allow config passthrough
      const defaultColumnConfig = {
        sortable: true,
        filter: true,
        editable: true
      };

      let sortModel = {};
      let filterModel = {};

      if (this.gridApi) {
        sortModel = this.gridApi.getSortModel();
        filterModel = this.gridApi.getFilterModel();
      }

      modelRecords({
        apollo: this.$apollo,
        model: this.model,
        attributes: this.columns,
        pageSize: this.pageSize,
        pageNumber: this.pageNumber,
        sortModel: sortModel,
        filterModel: filterModel
      })
        .then(response => {
          // FIXME: pluralize model instead of declaring model pluralized
          return response.data[this.model];
        })
        .then(result => {
          this.rowData = result.rows;
          this.totalPages = result.totalPages - 1;
          this.columnDefs = this.columns
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

      if (callback === "function") callback(this.rowData);
    }
  },
  beforeMount() {
    this.loadData();
  }
};
</script>

<style scoped>
/* FIXME: use more reliable method for full height ag-grid */
.grille-grid {
  height: calc(100vh - 220px);
  overflow-y: auto;
}
</style>
