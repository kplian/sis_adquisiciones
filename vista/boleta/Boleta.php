<?php
/****************************************************************************************
*@package pXP
*@file Boleta.php
*@author  (egutierrez)
*@date 25-03-2021 13:42:09
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                25-03-2021 13:42:09    egutierrez            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
var desde =0;
var hasta=0;
Phx.vista.Boleta=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.Boleta.superclass.constructor.call(this,config);
        this.init();
        //this.load({params:{start:0, limit:this.tam_pag}})
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'idboleta'
            },
            type:'Field',
            form:true 
        },
        {
            config:{
                name: 'nrodoc',
                fieldLabel: 'Nro Documento',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:-5
            },
            type:'TextField',
            filters:{pfiltro:'bolg.nrodoc',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'tipodocumento',
                fieldLabel: 'Tipo de Documento',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:-5
            },
            type:'TextField',
            filters:{pfiltro:'bolg.tipodocumento',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'otorgante',
                fieldLabel: 'Otorgante',
                allowBlank: true,
                anchor: '80%',
                gwidth: 200,
                maxLength:-5
            },
            type:'TextField',
            filters:{pfiltro:'bolg.otorgante',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'diasrestantes',
                fieldLabel: 'Dias Restantes',
                allowBlank: true,
                anchor: '80%',
                gwidth: 90
            },
            type:'NumberField',
            filters:{pfiltro:'bolg.diasrestantes',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'fechainicio',
                fieldLabel: 'Fecha Inicio',
                allowBlank: true,
                anchor: '80%',
                gwidth: 70,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'b.fechainicio',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'fechafin',
                fieldLabel: 'Fecha Fin',
                allowBlank: true,
                anchor: '80%',
                gwidth: 70,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:' b.fechafin',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'desc_estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100
            },
            type:'TextField',
            filters:{pfiltro:'bolg.desc_estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'fechaaccion',
                fieldLabel: 'Fecha Accion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 80,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'bolg.fechaaccion',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'paragarantizar',
                fieldLabel: 'Descripcion de Garantia',
                allowBlank: true,
                anchor: '80%',
                gwidth: 300
            },
            type:'TextField',
            filters:{pfiltro:'bolg.paragarantizar',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'gestor',
                fieldLabel: 'Gestor',
                allowBlank: true,
                anchor: '90%',
                gwidth: 200
            },
            type:'TextField',
            filters:{pfiltro:'bolg.gestor',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'responsable',
                fieldLabel: 'Responsable',
                allowBlank: true,
                anchor: '90%',
                gwidth: 200
            },
            type:'TextField',
            filters:{pfiltro:'responsable',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        }
    ],
    tam_pag:50,    
    title:'Boletas Garantia',
    ActSave:'../../sis_adquisiciones/control/Boleta/insertarBoleta',
    ActDel:'../../sis_adquisiciones/control/Boleta/eliminarBoleta',
    ActList:'../../sis_adquisiciones/control/Boleta/listarBoleta',
    id_store:'idboleta',
    fields: [
		{name:'idboleta', type: 'numeric'},
		{name:'nrodoc', type: 'string'},
		{name:'otorgante', type: 'string'},
		{name:'paragarantizar', type: 'string'},
		{name:'fechaaccion', type: 'date',dateFormat:'Y-m-d'},
		{name:'fechainicio', type: 'date',dateFormat:'Y-m-d'},
		{name:'fechafin', type: 'date',dateFormat:'Y-m-d'},
		{name:'estado', type: 'numeric'},
        {name:'desc_estado', type: 'string'},
		{name:'diasrestantes', type: 'numeric'},
		{name:'tipodocumento', type: 'string'},
		{name:'gestor', type: 'string'},
		{name:'cd_empleado_gestor', type: 'string'},
        {name:'responsable', type: 'string'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        
    ],
    sortInfo:{
        field: 'fechafin',
        direction: 'DESC'
    },
    bdel: false,
    bedit: false,
    bnew: false,
    bsave: false,
    onReloadPage:function(param){
        var me = this;
        console.log('llegando',param);
        this.initFiltro(param);
    },
    //
    initFiltro: function(param){
        this.store.baseParams=param;
        this.load( { params: { start:0, limit: this.tam_pag } });
    },
    }
)
</script>
        
        