<?php
/**
*@package pXP
*@file gen-SolicitudDet.php
*@author  (admin)
*@date 05-03-2013 01:28:10
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.SolicitudDet.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
		this.iniciarEventos();
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_solicitud_det'
			},
			type:'Field',
			form:true 
		},
		{
            config:{
                name: 'id_solicitud',
               inputType:'hidden'
            },
            type:'Field',
            form:true
        },
		{
            config:{
                name: 'id_centro_costo',
                fieldLabel: 'Centro Costo',
                allowBlank: false,
                emptyText : 'Centro Costo...',
                store : new Ext.data.JsonStore({
                            url:'../../sis_parametros/control/CentroCosto/listarCentroCostoCombo',
                            id : 'id_centro_costo',
                            root: 'datos',
                            sortInfo:{
                                    field: 'codigo_cc',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_centro_costo','codigo_cc'],
                            remoteSort: true,
                            baseParams:{par_filtro:'codigo_cc'}
                }),
                valueField: 'id_centro_costo',
               displayField: 'codigo_cc',
               gdisplayField: 'desc_centro_costo',
               hiddenName: 'id_centro_costo',
               forceSelection:true,
               typeAhead: true,
               triggerAction: 'all',
                listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               width:350,
               gwidth:350,
               minChars:2,
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_centro_costo']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cc.codigo_cc',type:'string'},
            id_grupo:1,
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
                            url:'../../sis_parametros/control/ConceptoIngas/listarConceptoIngas',
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
               gdisplayField: 'desc_concepto_ingas',
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
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_concepto_ingas']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'conig.desc_ingas',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
       
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'descripcion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 250,
				maxLength:1200
			},
			type:'TextArea',
			filters:{pfiltro:'sold.descripcion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
            config:{
                name: 'precio_unitario',
                currencyChar:' ',
                fieldLabel: 'Prec. Unit.',
                allowBlank: false,
                width:100,
                gwidth: 110
            },
            type:'MoneyField',
            filters:{pfiltro:'sold.precio_unitario',type:'numeric'},
            id_grupo:0,
            grid:true,
            form:true
        }
		,
        {
            config:{
                name: 'cantidad',
                fieldLabel: 'cantidad',
                allowBlank: false,
                width: 100,
                gwidth: 100,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'sold.cantidad',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        
       
        {
            config:{
                name: 'precio_total',
                fieldLabel: 'Prec. Total',
                currencyChar:' ',
                allowBlank: true,
                width: 100,
                gwidth: 120,
                disabled:true,
                maxLength:1245186
            },
             type:'MoneyField',
            filters:{pfiltro:'sold.precio_total',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
       
        {
            config:{
                name: 'precio_ga',
                fieldLabel: 'Monto Act. Ges.',
                currencyChar:' ',
                allowBlank: true,
                disabled:true,
                 width: 100,
                gwidth: 120,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'sold.precio_sg',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
       
        {
            config:{
                name: 'precio_sg',
                fieldLabel: 'Monto Sig. Ges.',
                currencyChar:' ',
                allowBlank: true,
                
                 width: 100,
                gwidth: 120,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'sold.precio_sg',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'id_orden_trabajo',
                fieldLabel: 'Orden Trabajo',
                allowBlank: true,
                emptyText : 'OT...',
                store : new Ext.data.JsonStore({
                            url:'../../sis_contabilidad/control/OrdenTrabajo/listarOrdentrabajo',
                            id : 'id_orden_trabajo',
                            root: 'datos',
                            sortInfo:{
                                    field: 'motivo_orden',
                                    direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_orden_trabajo','motivo_orden','desc_orden'],
                            remoteSort: true,
                            baseParams:{par_filtro:'motivo_orden'}
                }),
                valueField: 'id_orden_trabajo',
               displayField: 'motivo_orden',
               gdisplayField: 'desc_orden_trabajo',
               hiddenName: 'id_orden_trabajo',
               forceSelection:true,
               typeAhead: true,
               triggerAction: 'all',
                listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               width:350,
               gwidth:350,
               minChars:2,
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden_trabajo']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'ot.motivo_orden#ot.desc_orden',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        
        {
            config:{
                name: 'codigo_partida',
                fieldLabel: 'Cod. Partida',
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'par.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        }
        
        ,
		
		{
			config:{
				name: 'nombre_partida',
				fieldLabel: 'Partida',
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'par.nombre_partida',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
        
        {
            config:{
                name: 'nro_cuenta',
                fieldLabel: 'Bro Cta.',
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'cta.nro_cuenta',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		
		{
			config:{
				name: 'nombre_cuenta',
				fieldLabel: 'Cuenta',
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'cta.nombre_cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'codigo_auxiliar',
				fieldLabel: 'Cod. Auxiliar',
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'aux.codigo_auxiliar',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
        
        {
            config:{
                name: 'nombre_auxiliar',
                fieldLabel: 'Nom. Auxiliar',
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'aux.nombre_auxiliar',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		
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
			filters:{pfiltro:'sold.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'sold.fecha_reg',type:'date'},
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
			filters:{pfiltro:'sold.fecha_mod',type:'date'},
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
		}
	],
	
	title:'Detalle',
	ActSave:'../../sis_adquisiciones/control/SolicitudDet/insertarSolicitudDet',
	ActDel:'../../sis_adquisiciones/control/SolicitudDet/eliminarSolicitudDet',
	ActList:'../../sis_adquisiciones/control/SolicitudDet/listarSolicitudDet',
	id_store:'id_solicitud_det',
	fields: [
		{name:'id_solicitud_det', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'descripcion', type: 'string'},
		{name:'precio_unitario', type: 'numeric'},
		{name:'id_solicitud', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_orden_trabajo', type: 'numeric'},
		{name:'precio_sg', type: 'numeric'},
		{name:'id_concepto_ingas', type: 'numeric'},
		{name:'id_cuenta', type: 'numeric'},
		{name:'precio_total', type: 'numeric'},
		{name:'cantidad', type: 'numeric'},
		{name:'id_auxiliar', type: 'numeric'},
		{name:'precio_ga_mb', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_partida_ejecucion', type: 'numeric'},
		{name:'numero', type: 'string'},
		{name:'precio_ga', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'desc_centro_costo','codigo_partida',
		'nombre_partida','nro_cuenta',
		'nombre_cuenta',
		'codigo_auxiliar',
		'nombre_auxiliar',
		'desc_concepto_ingas',
         'desc_orden_trabajo'
		
	],
	sortInfo:{
		field: 'id_solicitud_det',
		direction: 'ASC'
	},
	
    loadValoresIniciales:function()
    {
        
        this.getComponente('id_solicitud').setValue(this.maestro.id_solicitud);
        Phx.vista.SolicitudDet.superclass.loadValoresIniciales.call(this);
    },
    
    
    
	bdel:true,
	bsave:false
	}
)
</script>
		
		