<?php
/**
*@package pXP
*@file gen-PresolicitudDet.php
*@author  (admin)
*@date 10-05-2013 05:04:17
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	ISSUE				FECHA					AUTHOR					DESCRIPCION
 * 	#1					11/12/2018				EGS						Se aumento el campo de precio
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresolicitudDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.PresolicitudDet.superclass.constructor.call(this,config);
		
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presolicitud_det'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name: 'id_presolicitud',
                inputType:'hidden'
            },
            type:'Field',
            form:true 
        },
        {
            config:{
                name: 'estado',
                fieldLabel: 'estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'pred.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
         
        {
            config:{
                    name:'id_centro_costo',
                    origen:'CENTROCOSTO',
                    baseParams:{filtrar:'grupo_ep'},
                    fieldLabel: 'Centro de Costos',
                    url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXDepto',
                    emptyText : 'Centro Costo...',
                    allowBlank:false,
                    gdisplayField:'codigo_cc',//mapea al store del grid
                    gwidth:200,
                    //renderer:function (value, p, record){return String.format('{0}', record.data['desc_centro_costo']);}
                    renderer:function(value, p, record){return String.format('{0}', record.data['codigo_cc']);}
                },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'cc.codigo_cc',type:'string'},
            grid:true,
            form:true
        },
        {
            config:{
                name: 'id_concepto_ingas',
                fieldLabel: 'Concepto',
                allowBlank: false,
                emptyText : 'Concepto...',
                store : new Ext.data.JsonStore({
                            url:'../../sis_parametros/control/ConceptoIngas/listarConceptoIngasPorPartidas',
                            id : 'id_concepto_ingas',
                            root: 'datos',
                            sortInfo:{
                                    field: 'desc_ingas',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_concepto_ingas','tipo','movimiento','desc_ingas'],
                            remoteSort: true,
                            baseParams:{par_filtro:'desc_ingas',movimiento:'gasto'}
                }),
                valueField: 'id_concepto_ingas',
               displayField: 'desc_ingas',
               gdisplayField: 'desc_ingas',
               hiddenName: 'id_concepto_ingas',
               forceSelection:true,
               typeAhead: true,
               triggerAction: 'all',
                listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               width:350,
               gwidth:200,
               minChars:2,
               tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_ingas}</p><strong>{tipo}</strong></div></tpl>',
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_ingas']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cig.desc_ingas',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descripcion',
                fieldLabel: 'descripcion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 200,
                maxLength:500
            },
            type:'TextArea',
            filters:{pfiltro:'pred.descripcion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'cantidad',
                fieldLabel: 'cantidad',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1245186
            },
            type:'NumberField',
            filters:{pfiltro:'pred.cantidad',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        //#1	11/12/2018	EGS	
        {
            config:{
                name: 'precio',
                fieldLabel: 'Precio',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:1245186
            },
            type:'NumberField',
            filters:{pfiltro:'pred.precio',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
         //#1	11/12/2018	EGS	
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'pred.estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'pred.fecha_reg',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu1.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'pred.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
	],
	
	title:'Presolicitud Detalle',
	ActSave:'../../sis_adquisiciones/control/PresolicitudDet/insertarPresolicitudDet',
	ActDel:'../../sis_adquisiciones/control/PresolicitudDet/eliminarPresolicitudDet',
	ActList:'../../sis_adquisiciones/control/PresolicitudDet/listarPresolicitudDet',
	id_store:'id_presolicitud_det',
	fields: [
		{name:'id_presolicitud_det', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'cantidad', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'id_solicitud_det', type: 'numeric'},
		{name:'id_presolicitud', type: 'numeric'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'codigo_cc','desc_ingas',
		{name:'precio', type: 'numeric'}, //#1	11/12/2018	EGS	
		{name:'id_solicitud', type: 'numeric'},

		
	],
	sortInfo:{
		field: 'id_presolicitud_det',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    onReloadPage:function(m){
        this.maestro=m;
        this.Cmp.id_concepto_ingas.store.baseParams.id_partidas= this.maestro.id_partidas;
        this.Cmp.id_centro_costo.store.baseParams.id_gestion= this.maestro.id_gestion;
        this.Cmp.id_centro_costo.store.baseParams.codigo_subsistema='ADQ';
        this.Cmp.id_centro_costo.store.baseParams.id_depto =this.maestro.id_depto;
        this.Cmp.id_centro_costo.modificado=true;
         this.Cmp.id_concepto_ingas.modificado=true;
        this.store.baseParams={id_presolicitud:this.maestro.id_presolicitud};
      
        this.load({params:{start:0, limit:this.tam_pag}})
    },
    loadValoresIniciales:function()
    {
        Phx.vista.PresolicitudDet.superclass.loadValoresIniciales.call(this);
        this.getComponente('id_presolicitud').setValue(this.maestro.id_presolicitud);
    }
})
</script>
		
		