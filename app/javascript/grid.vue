<template>
    <v-layout column full-height>
        <v-flex row>
            <v-card>
                <ag-grid-vue style="height: 100vw; width: 100vw"
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
            {headerName: 'Security Instrument', field: 'security_instrument'},
            {headerName: 'Settlement Date', field: 'settlement_date'},
            {headerName: 'Price', field: 'price', sortable: true}
        ];

        this.rowData = [
            {security_instrument: 'FN Fix-30 MBS', settlement_date: '11/12/2019', price: 105.32},
            {security_instrument: 'FN Fix-30 MBS', settlement_date: '11/12/2019', price: 105.32},
            {security_instrument: 'FN Fix-30 MBS', settlement_date: '11/12/2019', price: 105.32},
            {security_instrument: 'FN Fix-30 MBS', settlement_date: '11/12/2019', price: 105.32},
            {security_instrument: 'FN Fix-30 MBS', settlement_date: '11/12/2019', price: 105.32},
            {security_instrument: 'FN Fix-30 MBS', settlement_date: '11/12/2019', price: 105.32},
            {security_instrument: 'FN Fix-30 MBS', settlement_date: '11/12/2019', price: 105.32},
        ];
    }
}
</script>