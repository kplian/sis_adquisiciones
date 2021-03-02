<?php
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
var id_gestion=0;
var desde =0;
var hasta=0;
var num_tramite=0;
var id_proveedor=0;
var codigo_tcc=0;
Phx.vista.ReporteConsulta=Ext.extend(Phx.gridInterfaz,{
    
    constructor:function(config){
        var me = this;
        Phx.vista.ReporteConsulta.superclass.constructor.call(this,config);
        this.init();
        this.addButton('btnObs',{
            text :'Reporte Xls',
            iconCls : 'bchecklist',
            disabled: false,
            handler : this.Listado,
            tooltip : '<b>Reporte</b>'
        });
    },
    //
    Atributos:[
        {
            config:{
                name: 'num_tramite',
                fieldLabel: 'Num. Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:200,
                renderer:function(value,p,record){
                    if(record.data.usr_reg=='vitalia.penia'|| record.data.usr_reg=='shirley.torrez'|| record.data.usr_reg=='patricia.lopez'|| record.data.usr_reg=='patricia.lopez'){
                        return String.format('<b><font color="orange">{0}</font></b>', value);
                    }
                    else {
                        return value;
                    }
                }
            },
            type:'TextField',
            filters:{pfiltro:'op.num_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        /*{
            config: {
                name: 'id_proveedor',
                fieldLabel: 'Proveedor',
                anchor: '80%',
                tinit: false,
                allowBlank: false,
                origen: 'PROVEEDOR',
                gdisplayField: 'desc_proveedor',
                gwidth: 200,
                listWidth: '280',
                resizable: true
            },
            type: 'ComboRec',
            id_grupo: 1,
            bottom_filter: true,
            grid: true,
        },*/
        {
            config:{
                name: 'desc_proveedor',
                fieldLabel: 'Proveedor',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:200,
                renderer:function(value,p,record){
                    var x =record.data.desc_proveedor;
                    var s = x.replaceAll(',', '<br>');
                    return s;
                }
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
        },
        {
            config:{
                name: 'justificacion',
                fieldLabel: 'Justificacion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:200,
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
        },
        {
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_funcionario'
            },
            type:'Field',
            grid:false
        },
        {
            config:{
                name: 'desc_funcionario',
                fieldLabel: 'Funcionario',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:200,
            },
            type:'TextField',
            id_grupo:1,
            filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
            grid:true,
        },
        /*{
            config:{
                name: 'fecha_fin',
                fieldLabel: 'Fecha',
                allowBlank: false,
                gwidth: 80,
                format: 'd/m/Y', 
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'fecha_fin',type:'date'},
            id_grupo:1,
            grid:false
        },*/
        {
            config:{
                name: 'moneda',
                fieldLabel: 'Moneda',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:200,
            },
            type:'TextField',
            id_grupo:1,
            filters:{pfiltro:'cot.moneda',type:'string'},
            grid:true,
        },
        {
            config:{
                name: 'monto_total_adjudicado',
                currencyChar:' ',
                allowNegative:false,
                fieldLabel: 'Monto',
                allowBlank: false,
                disabled:true,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            valorInicial:0,
            filters:{pfiltro:'monto_total_adjudicado',type:'numeric'},
            id_grupo:1,
            grid:true,
        },
        {
            config:{
                name: 'monto_total_adjudicado_mb',
                currencyChar:' ',
                allowNegative:false,
                fieldLabel: 'Monto en Bs.',
                allowBlank: false,
                disabled:true,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            valorInicial:0,
            filters:{pfiltro:'monto_total_adjudicado_mb',type:'numeric'},
            id_grupo:1,
            grid:true,
        },
        /*{
            config:{
                name: 'fecha_reg',
                fieldLabel: 'Fecha Aprobacion',
                allowBlank: false,
                gwidth: 80,
                format: 'd/m/Y', 
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'pc.fecha_reg',type:'date'},
            id_grupo:1,
            grid:false
        },*/
        {
            config:{
                name: 'fecha_apro',
                fieldLabel: 'Fecha Aprobacion',
                allowBlank: false,
                gwidth: 80,
                format: 'd/m/Y', 
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'fecha_apro',type:'date'},
            id_grupo:1,
            grid:true
        },
        {
            config:{
                name: 'fecha_adju',
                fieldLabel: 'Fecha Adjudicacion',
                allowBlank: false,
                gwidth: 80,
                format: 'd/m/Y', 
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'oc.fecha_adju',type:'date'},
            id_grupo:1,
            grid:true
        },
        {
            config:{
                name: 'cecos',
                fieldLabel: 'Cecos',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:200,
                renderer:function(value,p,record){
                    var x =record.data.cecos.replaceAll(',', '<br>');
                    return x;
                }
            },
            type:'TextField',
            id_grupo:1,
            filters:{pfiltro:'oc.cecos',type:'string'},
            grid:true,
        },
        {
            config:{
                name: 'id_proceso_wf',
                fieldLabel: 'id_proceso_wf',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:255,
            },
            type: 'NumberField',
            id_grupo:1,
            grid:false
        },
        {
            config:{
                name: 'diferencia',
                fieldLabel: 'Diferencia',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:255,
                renderer:function (value,p,record){
                    var datefrom=record.data.fecha_apro;
                    var dateto=record.data.fecha_adju;
                    var count = 0;
                    var curDate = datefrom;
                    if(curDate <= dateto){
                        while (curDate <= dateto) {
                            var dayOfWeek = curDate.getDay();
                            if(!((dayOfWeek == 6) || (dayOfWeek == 0)))
                            count++;
                            curDate.setDate(curDate.getDate() + 1);
                        }
                        return String.format('<b><font color="green">{0}</font></b>', count);
                    }else{
                        return String.format('<b><font color="orange">{0}</font></b>', -1);
                    }
                }
            },
            type: 'NumberField',
            id_grupo:1,
            grid:true
        },
        
    ],
    //
    tam_pag:50,
    title:'das',
    ActList:'../../sis_adquisiciones/control/PlanPagoRep/listarReporteConsulta',
    id_store:'num_tramite',
    fields: [
        {name:'num_tramite', type: 'string'},
        {name:'justificacion', type: 'string'},
        //{name:'id_proveedor', type: 'numeric'},
        {name:'desc_proveedor', type: 'string'},
        {name:'id_funcionario', type: 'numeric'},
        {name:'desc_funcionario', type: 'string'},
        {name:'cecos', type: 'string'},
        {name:'moneda', type: 'string'},
        'id_moneda','diferencia','id_proceso_wf',
        'monto_total_adjudicado','monto_total_adjudicado_mb',
        {name:'fecha_adju', type: 'date',dateFormat:'Y-m-d'},
        //{name:'fecha_coti', type: 'date',dateFormat:'Y-m-d'},
        //{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d'},
        {name:'fecha_apro', type: 'date',dateFormat:'Y-m-d'},
    ],
    //
    bedit:false,
    bnew:false,
    bdel:false,
    //
    onReloadPage:function(param){
        var me = this;
        id_gestion=param.id_gestion;
        desde=param.desde;
        hasta=param.hasta;
        num_tramite=param.num_tramite;
        id_proveedor=param.id_proveedor;
        codigo_tcc=param.codigo_tcc;
        id_categoria_compra=param.id_categoria_compra;
        this.initFiltro(param);
    },
    //
    initFiltro: function(param){
        this.store.baseParams=param;
        this.load( { params: { start:0, limit: this.tam_pag } });
    },
    //
    Listado : function(m)
    {
        this.maestro = m;
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_adquisiciones/control/PlanPagoRep/ListadoReporte',
            params:
            {
                'id_gestion':id_gestion,
                'desde':desde,
                'hasta':hasta,
                'num_tramite':num_tramite,
                'id_proveedor':id_proveedor,
                'codigo_tcc':codigo_tcc,
                'id_categoria_compra':id_categoria_compra
            },
            success: this.successExport,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    },
    //

})
</script>