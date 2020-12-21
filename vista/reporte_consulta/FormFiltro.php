<?php
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.FormFiltro=Ext.extend(Phx.frmInterfaz,{
    constructor:function(config)
    {   
        this.panelResumen = new Ext.Panel({html:''});
        this.Grupos = 
        [
            {
                xtype: 'fieldset',
                border: false,
                autoScroll: true,
                layout: 'form',
                items: [],
                id_grupo: 0
            },this.panelResumen
        ];
        Phx.vista.FormFiltro.superclass.constructor.call(this,config);
        this.init(); 
        this.iniciarEventos();
        if(config.detalle){
            //cargar los valores para el filtro
            this.loadForm({data: config.detalle});
            var me = this;
            setTimeout(function(){
                me.onSubmit()
            }, 1000);
        }
    },
    
    Atributos:[
        {
            config:{
                name : 'id_gestion',
                origen : 'GESTION',
                fieldLabel : 'Gestion',
                gdisplayField: 'desc_gestion',
                allowBlank : true,
                width: 150,
                anchor: '90%',
            },
            type : 'ComboRec',
            id_grupo : 0,
            form : true
        },
        {
            config:{
                name: 'desde',
                fieldLabel: 'Desde',
                allowBlank: true,
                format: 'd/m/Y',
                width: 150,
                anchor: '90%',
            },
            type: 'DateField',
            id_grupo: 0,
            form: true
        },
        {
            config:{
                name: 'hasta',
                fieldLabel: 'Hasta',
                allowBlank: true,
                format: 'd/m/Y',
                width: 150,
                anchor: '90%',
            },
            type: 'DateField',
            id_grupo: 0,
            form: true
        },
        {
            config:{
                name: 'id_depto',
                fieldLabel: 'Depto',
                allowBlank: true,
                anchor: '90%',
                origen: 'DEPTO',
                tinit: false,
                baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'TES',modulo:'OP'},
                gdisplayField:'nombre_depto',
                gwidth: 150
            },
            type:'ComboRec',
            filters:{pfiltro:'dep.nombre',type:'string'},
            id_grupo:1,
            grid:false,
            form:false
        },
        {
            config:{
                name: 'num_tramite',
                fieldLabel: 'Nro. Trámite',
                allowBlank: true,
                resizable:true,
                emptyText: 'Nro. Trámite',
                store: new Ext.data.JsonStore({
                    url: '../../sis_adquisiciones/control/PlanPagoRep/ListarNumTraObp',
                    id: 'num_tramite',
                    root: 'datos',
                    sortInfo:{
                        field: 'num_tramite',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['num_tramite'],
                    remoteSort: true,
                    baseParams:{par_filtro:'num_tramite'}
                }),
                valueField: 'num_tramite',
                displayField: 'num_tramite',
                gdisplayField: 'num_tramite',
                hiddenName: 'num_tramite',
                hideTrigger:false,
                queryParam:'query',
                triggerAction: 'all',
                lazyRender:false,
                queryDelay:1000,
                pageSize:5,
                forceSelection:false,
                typeAhead: false,
                anchor: '90%',
                gwidth: 100,
                mode: 'remote',
                minChars:1,
            },
            type:'ComboBox',
            filters:{pfiltro:'obp.num_tramite',type:'string'},
            bottom_filter: true,
            id_grupo:0,
            grid:false,
            form:true
        },
        {
            config: {
                name: 'id_proveedor',
                fieldLabel: 'Proveedor',
                anchor: '90%',
                tinit: false,
                allowBlank: true,
                origen: 'PROVEEDOR',
                gdisplayField: 'desc_proveedor',
                gwidth: 150,
                listWidth: '280',
                resizable: true
            },
            type: 'ComboRec',
            id_grupo: 1,
            filters:{pfiltro:'pv.desc_proveedor',type:'string'},
            bottom_filter: true,
            grid: true,
            form: true
        },
        {
            config: {
                name: 'codigo_tcc',
                fieldLabel: 'Centro Costo/Proyecto',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_parametros/control/TipoCc/listartipoCcAll',
                    id: 'id_tipo_cc',
                    root: 'datos',
                    sortInfo: {
                        field: 'codigo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_cc', 'codigo', 'descripcion'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'tcc.codigo#tcc.descripcion'}
                }),
                tpl:'<tpl for=".">\
                    <div class="x-combo-list-item"><p><b>Codigo:</b>{codigo}</p>\
                    <p><b>Descripcion: </b>{descripcion}</p>\
                    </div></tpl>',
                valueField: 'codigo',
                displayField: 'codigo',
                gdisplayField: 'codigo_tcc',
                forceSelection: false,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '90%',
                gwidth: 100,
                minChars: 2,
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'tcc.codigo#tcc.descripcion',type: 'string'},
            grid: true,
            form: true
        },
        {
            config: {
                name: 'id_categoria_compra',
                hiddenName: 'id_categoria_compra',
                fieldLabel: 'Categoria de Compra',
                typeAhead: false,
                allowBlank: true,
                emptyText: 'Categorias...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_adquisiciones/control/CategoriaCompra/listarCategoriaCompra',
                    id: 'id_categoria_compra',
                    root: 'datos',
                    sortInfo: {
                        field: 'catcomp.nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_categoria_compra', 'nombre', 'codigo'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams: { par_filtro: 'catcomp.nombre#catcomp.codigo', codigo_subsistema: 'ADQ'}
                }),
                valueField: 'id_categoria_compra',
                displayField: 'nombre',
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 200,
                listWidth:180,
                minChars: 2,
                anchor: '90%',
                tpl: '<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p>Codigo: <strong>{codigo}</strong> </div></tpl>'
            },
            type: 'ComboBox',
            id_grupo: 0,
            form: true
        },
    ],

    labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
    east: {
        url: '../../../sis_adquisiciones/vista/reporte_consulta/ReporteConsulta.php',
        title: 'Listado',
        width: '80%',
        height: '80%',
        cls: 'ReporteConsulta'
    },
    title: 'Filtro',
    // Funcion guardar del formulario
    onSubmit: function(o) {
        var me = this;
        if (me.form.getForm().isValid()) {
            var parametros = me.getValForm();
            var gest=this.Cmp.id_gestion.lastSelectionText;
            //var dpto=this.Cmp.id_depto.lastSelectionText;
            var nro_tram=this.Cmp.num_tramite.lastSelectionText;
            var codtcc=this.Cmp.codigo_tcc.getValue();
            this.onEnablePanel(this.idContenedor + '-east',
                Ext.apply(parametros,{	
                    'gest': gest,
                    //'dpto': dpto,
                    'num_tramite' : nro_tram,
                    'codigo_tcc' : codtcc
                })
            );
        }
    },
    //
    iniciarEventos:function(){
    },

    loadValoresIniciales: function(){
        Phx.vista.FormFiltro.superclass.loadValoresIniciales.call(this);	
    }
    
})
</script>