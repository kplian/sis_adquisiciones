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
                    name: 'desde',
                    fieldLabel: 'Desde',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 150,
                    anchor: '95%',
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'hasta',
                    fieldLabel: 'Hasta',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 150,
                    anchor: '95%',
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config: {
                    name: 'id_gestor',
                    fieldLabel: 'Gestor',
                    allowBlank: true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_adquisiciones/control/Boleta/listarPersona',
                        id: 'id_persona',
                        root: 'datos',
                        sortInfo: {
                            field: 'nom',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_persona', 'nombre'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'nombre'}
                    }),
                    valueField: 'id_persona',
                    displayField: 'nombre',
                    gdisplayField: 'nombre',
                    hiddenName: 'id_persona',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    anchor: '95%',
                    gwidth: 150,
                    minChars: 2,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['nombre']);
                    },
                    listeners: {
                        beforequery: function(qe){
                            delete qe.combo.lastQuery;
                        }
                    },
                },
                type: 'ComboBox',
                id_grupo: 0,
                filters: {pfiltro: 'p.nombre',type: 'string'},
                grid: true,
                form: true
            },
            {
                config : {
                    name:'estado',
                    fieldLabel : 'Estado',
                    resizable:true,
                    allowBlank:true,
                    emptyText:'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_parametros/control/Catalogo/listarCatalogoCombo',
                        id: 'id_catalogo',
                        root: 'datos',
                        sortInfo:{
                            field: 'orden',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_catalogo','codigo','descripcion'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams: {par_filtro:'descripcion',cod_subsistema:'ADQ',catalogo_tipo:'boleta_estado'}
                    }),
                    enableMultiSelect:true,
                    valueField: 'codigo',
                    displayField: 'descripcion',
                    gdisplayField: 'descripcion',
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:15,
                    queryDelay: 1000,
                    anchor: '95%',
                    gwidth: 150,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['descripcion']);
                    },
                    listeners: {
                        beforequery: function(qe){
                            delete qe.combo.lastQuery;
                        }
                    },
                },
                type:'ComboBox',
                id_grupo:0,
                grid:true,
                form:true
            },
            {
                config: {
                    name: 'otorgante',
                    fieldLabel: 'Banco',
                    allowBlank: true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_adquisiciones/control/Boleta/listarOtorgante',
                        id: 'otorgante',
                        root: 'datos',
                        sortInfo: {
                            field: 'otorgante',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['otorgante'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'otorgante'}
                    }),
                    valueField: 'otorgante',
                    displayField: 'otorgante',
                    gdisplayField: 'otorgante',
                    hiddenName: 'otorgante',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    anchor: '95%',
                    gwidth: 150,
                    minChars: 2,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['otorgante']);
                    },
                    listeners: {
                        beforequery: function(qe){
                            delete qe.combo.lastQuery;
                        }
                    },
                },
                type: 'ComboBox',
                id_grupo: 0,
                filters: {pfiltro: 'otorgante',type: 'string'},
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'cod_responsable',
                    fieldLabel: 'Responsable',
                    allowBlank: true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_adquisiciones/control/Boleta/listarResponsable',
                        id: 'id_persona',
                        root: 'datos',
                        sortInfo: {
                            field: 'nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_persona', 'nombre'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'nombre'}
                    }),
                    valueField: 'id_persona',
                    displayField: 'nombre',
                    gdisplayField: 'nombre',
                    hiddenName: 'id_persona',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    anchor: '95%',
                    gwidth: 150,
                    minChars: 2,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['nombre']);
                    },
                    listeners: {
                        beforequery: function(qe){
                            delete qe.combo.lastQuery;
                        }
                    },
                },
                type: 'ComboBox',
                id_grupo: 0,
                //filters: {pfiltro: 'p.nombre',type: 'string'},
                grid: true,
                form: true
            },
        ],

        labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
        east: {
            url: '../../../sis_adquisiciones/vista/boleta/Boleta.php',
            title: 'Boletas',
            width: '80%',
            height: '80%',
            cls: 'Boleta'
        },
        title: 'Filtro',
        // Funcion guardar del formulario
        onSubmit: function(o) {
            var me = this;
            if (me.form.getForm().isValid()) {
                var parametros = me.getValForm();
                this.onEnablePanel(this.idContenedor + '-east',
                    Ext.apply(parametros)
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