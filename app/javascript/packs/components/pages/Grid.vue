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
          @cell-value-changed="onCellEdit"
        >
        </ag-grid-vue>
        <Confirm ref="confirm"></Confirm>
        <v-toolbar>
          <v-toolbar-items>
            <v-pagination
              v-model="pageNumber"
              class="my-4"
              :length="totalPages"
              :total-visible="5"
              @input="loadData"
            ></v-pagination>

            <v-divider inset vertical></v-divider>

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
    applyChanges(params) {
      let rowData = [];
      this.gridApi.forEachNode(node => {
        if (node.newOrModified) rowData.push(JSON.stringify(node.data));
      });

      // FIXME: generalize for CRUD
      this.$refs.confirm
        .open("Update", "Are you sure?", { color: "green" })
        .then(confirm => {
          if (!confirm) return;
          modelUpdate({
            apollo: this.$apollo,
            ...{ model: this.model, jsonArray: rowData }
          }).then(response => {
            if (response.data.delete.result === true) {
              this.loadData(this.pageNumber, rowData => {
                //this.gridApi.removeItems(selectedNodes);
                //this.gridApi.refreshCells();
                this.gridApi.setRowData(rowData);
              });
            }
          });
        });
    },
    handleModelDelete() {
      let selectedNodes = this.gridApi.getSelectedNodes();
      let ids = selectedNodes.map(node => node.data.id);

      this.$refs.confirm
        .open("Delete", "Are you sure?", { color: "red" })
        .then(confirm => {
          if (!confirm) return;
          modelDelete({
            apollo: this.$apollo,
            ...{ model: this.model, ids: ids }
          }).then(response => {
            if (response.data.delete.result === true) {
              this.loadData(rowData => {
                this.gridApi.setRowData(rowData);
              });
            }
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

      modelRecords({
        apollo: this.$apollo,
        model: this.model,
        attributes: this.columns,
        pageSize: this.pageSize,
        pageNumber: this.pageNumber
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
