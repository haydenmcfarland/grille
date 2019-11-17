<template>
    <ag-grid-vue style="width: 500px; height: 300px;"
        class="ag-theme-balham-dark"
        :columnDefs="columnDefs"
        :rowData="rowData"
        :modules="modules">
    </ag-grid-vue>
</template>

<script>
import "@ag-grid-community/all-modules/dist/styles/ag-grid.css";
import "@ag-grid-community/all-modules/dist/styles/ag-theme-balham-dark.css";

import { AgGridVue } from '@ag-grid-community/vue';
import {AllCommunityModules} from '@ag-grid-community/all-modules';

export default {
    data() {
        return {
            columnDefs: null,
            rowData: null,
            modules: AllCommunityModules
        }
    },
    components: {
        AgGridVue
    },
    beforeMount() {
        this.columnDefs = [
            {headerName: 'Make', field: 'make'},
            {headerName: 'Model', field: 'model'},
            {headerName: 'Price', field: 'price', sortable: true}
        ];

        this.rowData = [
            {make: 'Toyota', model: 'Celica', price: 35000},
            {make: 'Ford', model: 'Mondeo', price: 32000},
            {make: 'Porsche', model: 'Boxter', price: 72000}
        ];
    }
}
</script>