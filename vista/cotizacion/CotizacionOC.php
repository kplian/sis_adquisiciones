<?php
/**
*@package pXP
*@file Cotizacion.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-03-2013 14:48:35  
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *  * * ISSUE            FECHA:		      AUTOR       DESCRIPCION

 #16               20/01/2020        RAC KPLIAN        Creacion, Mejor el rendimiento de la interface de Ordenes y Cotizaciones, issue #16
#18                 22/05/2020          EGS             Se agregan campos
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CotizacionOC=Ext.extend(Phx.gridInterfaz,{
    tam_pag: 50,
    bottom_filter: true,
    egrid: false,
    tipoStore: 'GroupingStore',//GroupingStore o JsonStore 
    remoteGroup: true,
    groupField:'num_tramite',
    viewGrid: new Ext.grid.GroupingView({
        forceFit:false,
        //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
    }),
    
    constructor: function(config){
	    this.maestro = config;
		//llama al constructor de la clase padre
    	Phx.vista.CotizacionOC.superclass.constructor.call(this,config);
    	
    	//RAC: Se agrega menú de reportes de adquisiciones
        this.addBotones();
    	this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Docs',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );
        
        this.addButton('diagrama_gantt',{text:'Gantt',iconCls: 'bgantt',disabled:true,handler:this.diagramGantt,tooltip: '<b>Diagrama gantt de proceso macro</b>'});
        
        this.init();
      
        this.store.baseParams={tipo_interfaz: this.nombreVista}; 
        this.load({params:{start:0, limit:this.tam_pag}});
	
	},


	
	 diagramGantt:function(){           
            var data=this.sm.getSelected().data.id_proceso_wf;
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                params:{'id_proceso_wf':data},
                success:this.successExport,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });         
    },
    
    addBotones: function() {
        this.menuAdq = new Ext.Toolbar.SplitButton({
            id: 'btn-adqrep-' + this.idContenedor,
            text: 'Rep.',
            disabled: true,
            iconCls : 'bpdf32',
            scope: this,
            menu: [{
                id:'b-btnReporte-' + this.idContenedor,
                text: 'Cotización',
                tooltip: '<b>Reporte de  Cotización</b>',
                handler: this.onButtonReporte,
                scope: this
            }, {
                id:'b-btnRepOC-' + this.idContenedor,
                text: 'Orden de Compra',
                tooltip: '<b>Reporte de Orden de Compra</b>',
                handler:this.onButtonRepOC,
                scope: this
            }, {
                id:'b-btnRepCarta-' + this.idContenedor,
                text: 'Carta de Adjudicación',
                tooltip: '<b>Plantilla de la carta de adjudicación</b>',
                handler:this.onButtonCartaAdj,
                scope: this
            }
        ]});
        
        //Adiciona el menú a la barra de herramientas
        this.tbar.add(this.menuAdq);
    },
	
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cotizacion'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_proceso_compra'
            },
            type:'Field',
            form:true 
        },
        {
            config:{
                name: 'require_contrato',
                fieldLabel: 'Contrato',
                allowBlank: true,
                anchor: '80%',
                gwidth: 70,
                maxLength:200,
                renderer: function(value,p,record){
                         if(record.data.requiere_contrato=='si'){
                             return String.format('<div title="Requiere elaboración de contrato"><b><font color="green"><i class="fa fa-file-o  fa-2x"></i> Si</font></b></div>', value);
                         }
                        else {
                             return String.format('<div title="Solamente requiere orden de compra o servicio"><b><i class="fa fa-file  fa-2x"></i> No</b></div>', value);
                        }
                 }
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'num_tramite',
                fieldLabel: 'N# Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:200,
                renderer: function(value,p,record){
                        if(record.data.correo_oc=='bloqueado'){
                             return String.format('<div title="Envio de correo con la orden de compra bloqueado"><b><font color="red">{0}</font></b>', value);
                         }
                        else if(record.data.correo_oc=='pendiente'){
                             return String.format('<div title="Acuse de recibo de la OC en espera"><b><font color="orange">{0}</font></b></div>', value);
                        }
                        else if(record.data.correo_oc=='acuse'){
                             return String.format('<div title="Acuse de OC recibido"><b><font color="green">{0}</font></b></div>', value);
                        }
                        else{
                            return String.format('{0}', value);
                        }}
            },
            type:'TextField',
            filters:{pfiltro:'num_tramite',type:'string'},
            bottom_filter: true,
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 110,
                renderer: function(value,p,record){
                         if(record.data.estado=='anulado'){
                             return String.format('<b><font color="red">{0}</font></b>', value);
                         }
                        else if(record.data.estado=='adjudicado'){
                             return String.format('<div title="Esta cotización tiene items adjudicados"><b><font color="green">{0}</font></b></div>', value);
                        }
                        else{
                            return String.format('{0}', value);
                        }},
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'estado',
                     options: ['borrador','cotizado','adjudicado','recomendado','contro_pendiente','contrato_eleborado','pago_habilitado','finalizada','anulada'],	
	       		 	 type:'list'},
            
            id_grupo:1,
            bottom_filter: true,
            grid:true,
            form:false
        },
        
         ///#1 			19/09/2018			EGS			
		{
			config:{
				name: 'id_proveedor',
				fieldLabel: 'Proveedor',
				allowBlank: false,
				emptyText: 'Proveedor ...',
				store: new Ext.data.JsonStore({

	    					url: '../../sis_parametros/control/Proveedor/listarProveedorCombos',
	    					id: 'id_proveedor',
	    					root: 'datos',
	    					sortInfo:{
	    						field: 'desc_proveedor',
	    						direction: 'ASC'
	    					},
	    					totalProperty: 'total',
	    					fields: ['id_proveedor','codigo','desc_proveedor','nit'],
	    					// turn on remote sorting
	    					remoteSort: true,
	    					baseParams:{par_filtro:'codigo#desc_proveedor#nit'}
	    				}),	
        	    valueField: 'id_proveedor',
        	    displayField: 'desc_proveedor',
        	    gdisplayField: 'desc_proveedor',
        	    hiddenName: 'id_proveedor',
        	    triggerAction: 'all',
        	    //queryDelay:1000,
        	    pageSize:10,
				forceSelection: true,
				typeAhead: false,
				allowBlank: false,
				anchor: '80%',
				gwidth: 180,
				mode: 'remote',
				minChars:1,
				renderer: function(value,p,record){
                        if(record.data.estado=='anulado'){
                             return String.format('<b><font color="red">{0}</font></b>', record.data['desc_proveedor']);
                         }
                        else if(record.data.estado=='adjudicado'){
                             return String.format('<div title="Esta cotización tiene items adjudicados"><b><font color="green">{0}</font></b></div>', record.data['desc_proveedor']);
                        }
                        else{
                            return String.format('{0}', record.data['desc_proveedor']);
                        }}
			},
	           			
			type:'ComboBox',
			filters:{pfiltro:'desc_proveedor',type:'string'},
			bottom_filter: true,
			id_grupo:1,
			grid:true,
			form:false
		},
		 ///#1 			19/09/2018			EGS	
        {
            config:{
                name: 'numero',
                fieldLabel: 'Numero Sol',
                allowBlank: true,
                anchor: '80%',
                gwidth: 140,
                renderer: function(value,p,record){
                        if(record.data.estado=='anulado'){
                             return String.format('<b><font color="red">{0}</font></b>', value);
                         }
                        else if(record.data.estado=='adjudicado'){
                             return String.format('<div title="Esta cotización tiene items adjudicados"><b><font color="green">{0}</font></b></div>', value);
                        }
                        else{
                            return String.format('{0}', value);
                        }},
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'numero',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'numero_oc',
                fieldLabel: 'Numero O.C.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 140,
                renderer: function(value,p,record){
                        if(record.data.estado=='anulado'){
                             return String.format('<b><font color="red">{0}</font></b>', value);
                         }
                        else if(record.data.estado=='adjudicado'){
                             return String.format('<b><font color="green">{0}</font></b>', value);
                         
                        
                        }
                        else{
                            return String.format('{0}', value);
                        }},
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'numero_oc',type:'string'},
            bottom_filter:true,
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'fecha_coti',
                fieldLabel: 'Fecha Cotiz.',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'fecha_coti',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                 allowBlank:false,
                fieldLabel:'Moneda',
                gdisplayField:'desc_moneda',//mapea al store del grid
                gwidth:50,
                 renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type:'ComboRec',
            id_grupo:1,
            filters:{   
                pfiltro:'moneda#desc_moneda',
                type:'string'
            },
            grid:true,
            form:false
          },
          {
            config:{
                name: 'total_cotizado',
                fieldLabel: 'Total Cotizado',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100
            },
            type:'NumberField',
            filters:{pfiltro:'total_cotizado',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
          {
            config:{
                name: 'total_adjudicado_mb',
                fieldLabel: 'Total Adj (BS)',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100
            },
            type:'NumberField',
            filters:{pfiltro:'total_adjudicado_mb',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        
        
        {
            config:{
                name: 'tipo_cambio_conv',
                fieldLabel: 'Tipo de Cambio',
                allowBlank: false,
                anchor: '80%',
                hidden: true,
                gwidth: 100,
				decimalPrecision : 10
            },
            type:'NumberField',
            filters:{pfiltro:'tipo_cambio_conv',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'lugar_entrega',
				fieldLabel: 'Lugar Entrega',
				allowBlank: true,
				anchor: '80%',
				hidden: true,
				gwidth: 100,
				maxLength:450
			},
			type:'TextArea',
			filters:{pfiltro:'lugar_entrega',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'forma_pago',
				fieldLabel: 'Forma de pago',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:450
			},
			type:'TextArea',
			filters:{pfiltro:'forma_pago',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		
		 //#2 			21/09/2018			EGS
		{
			config: {
				name: 'tipo_entrega',
				fieldLabel: 'Tipo Entrega',
				anchor: '95%',
				tinit: false,
				allowBlank: false,
				origen: 'CATALOGO',
				gdisplayField: 'tipo_entrega',
				hiddenName: 'tipo_entrega',
				gwidth: 55,
				baseParams:{
					cod_subsistema:'ADQ',
					catalogo_tipo:'ttipo_entrega'
				},
				valueField: 'codigo',
				hidden: false
			},
			
			type: 'ComboRec',
			filters:{pfiltro:'tipo_entrega',type:'string'},
			id_grupo: 0,
			grid: true,
			form: false
		},
		 //#2 	21/09/2018	EGS
        {
            config:{
                name: 'tiempo_entrega',
                qtip:'Dias en que se espera la entrega a partir del dia siguiente de la emision de la OC',
                fieldLabel: 'Tiempo de entrega',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:150
            },
            type:'TextField',
            filters:{pfiltro:'tiempo_entrega',type:'string'},
            valorInicial:'5 días a partir del dia siguiente de emitida la presente orden',
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'fecha_venc',
				gtipo:'Fechas estimada de vencimiento',
				fieldLabel: 'Fecha Venc',
				qtip:'Fecha de vencimiento de la cotizacion',
				allowBlank: true,
				
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_venc',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
    
        {
            config:{
                name: 'fecha_entrega',
                fieldLabel: 'Fecha Entrega/Inicio',
                qtip:'Fecha de entrar o inicio de servicio segun el proveedor',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'fecha_entrega',type:'date'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'obs',
				fieldLabel: 'Glosa',
				allowBlank: true,
				anchor: '80%',
				height:'150',
				gwidth: 100
			},
			type:'TextArea',
			filters:{pfiltro:'obs',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_adju',
				fieldLabel: 'Fecha Adju',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_adju',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'nro_contrato',
				fieldLabel: 'Nro Contrato',			
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
			type:'TextField',
			filters:{pfiltro:'nro_contrato',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'tiene_form500',
				fieldLabel: 'Form 500',
				gwidth: 70,
				maxLength:50,
                renderer: function(value,p,record){
                         if(record.data.tiene_form500 == 'requiere'){
                             return String.format('<b><font color="red">{0}</font></b>', value);
                         }
                        else {
                             return String.format('<b>{0}</b>', value);
                        }
                 }
			},
			type:'TextField',
			filters:{pfiltro:'tiene_form500',type:'list',options: ['si','no','requiere']},
			id_grupo:1,
			grid:false,
			form:false
		},
		{
			config:{
				name: 'funcionario_contacto',
				fieldLabel: 'Func Contacto',
				qtip:'Funcionario de contacto para el proveedor',
				allowBlank: true,
				anchor: '100%',
				gwidth: 300,
				maxLength:50
			},
			type:'TextField',
			filters:{pfiltro:'funcionario_contacto',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'telefono_contacto',
				fieldLabel: 'Telefono Contacto',
				qtip:'Telefono de contacto para el proveedor',
				allowBlank: true,
				anchor: '100%',
				gwidth: 300,
				maxLength:50
			},
			type:'TextField',
			filters:{pfiltro:'telefono_contacto',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'correo_contacto',
				fieldLabel: 'Correo de Contacto',
				qtip:'Correo de contacto para el proveedor',
				allowBlank: true,
				anchor: '100%',
				gwidth: 300,
				maxLength:50
			},
			type:'TextField',
			filters:{pfiltro:'correo_contacto',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'prellenar_oferta',
				fieldLabel: 'Prellenar Cotización',
				qtip:'Copia los precios la cantidad y precio ofertado de la solicitud de compra',
				allowBlank: true,
				anchor: '40%',
				gwidth: 50,
				maxLength:2,
				emptyText:'si/no...',       			
       			typeAhead: true,
       		    triggerAction: 'all',
       		    lazyRender:true,
       		    mode: 'local',
       		    value:'no',
       		    valueField: 'prellenar_oferta',       		    
       		   // displayField: 'descestilo',
       		    store: ['si','no']
			},
			type:  'ComboBox',
			valorInicial: 'si',
			id_grupo: 1,
			filters: {	pfiltro:'prellenar_oferta',
	       		         type: 'list',
	       				 options: ['si','no']
	       		 	},
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
			filters:{pfiltro:'estado_reg',type:'string'},
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
			filters:{pfiltro:'fecha_reg',type:'date'},
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
			filters:{pfiltro:'usr_reg',type:'string'},
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
			filters:{pfiltro:'fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				hidden: true,
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usr_mod',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'cecos',
				fieldLabel: 'Cecos',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:450
			},
			type:'TextArea',		
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'total',
				fieldLabel: 'Cant Total',
				allowBlank: true,
				anchor: '80%',
				height:'150',
				gwidth: 100
			},
			type:'NumberField',
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'nro_cuenta',
				fieldLabel: 'Cuentas',
				allowBlank: true,
				anchor: '80%',
				height:'150',
				gwidth: 100
			},
			type:'NumberField',			
			id_grupo:1,
			grid:true,
			form:false
		},
        {//#18
            config:{
                name: 'codigo_proceso',
                fieldLabel: 'Codigo Proceso',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {//#18
            config:{
                name: 'desc_categoria_compra',
                fieldLabel: 'Categoria compra',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
	],
	
	title:'Cotizaciones',
	ActList:'../../sis_adquisiciones/control/Cotizacion/listarCotizacion',
	id_store:'id_cotizacion',
	fields: [
		{name:'id_cotizacion', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'lugar_entrega', type: 'string'},
		{name:'tipo_entrega', type: 'string'},
		{name:'fecha_coti', type: 'date',dateFormat:'Y-m-d'},
		'numero_oc',
		{name:'id_proveedor', type: 'numeric'},
		{name:'desc_proveedor', type: 'string'},
		{name:'porc_anticipo', type: 'numeric'},
		{name:'precio_total', type: 'numeric'},
		{name:'fecha_entrega', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_moneda', type: 'numeric'},
		{name:'moneda', type: 'string'},
		{name:'id_proceso_compra', type: 'numeric'},
		{name:'id_solicitud', type: 'numeric'},
		{name:'id_categoria_compra', type: 'numeric'},
		{name:'fecha_venc', type: 'date',dateFormat:'Y-m-d'},
		{name:'obs', type: 'string'},
		{name:'fecha_adju', type: 'date',dateFormat:'Y-m-d'},
		{name:'nro_contrato', type: 'string'},
		{name:'porc_retgar', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'email','desc_moneda','tipo_cambio_conv','id_estado_wf','id_proceso_wf','numero',
		'num_tramite',
		{name:'id_obligacion_pago', type: 'numeric'},'tiempo_entrega',
		'funcionario_contacto',
        'telefono_contacto',
        'correo_contacto', 'correo_oc',
        'prellenar_oferta', 'forma_pago', 'requiere_contrato','total_adjudicado','total_cotizado','total_adjudicado_mb','tiene_form500','total','cecos'
        ,'nro_cuenta','codigo_proceso','desc_categoria_compra'//#18
		
	],
    rowExpander: new Ext.ux.grid.RowExpander({
	        tpl : new Ext.Template(
	            '<br>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Solicitud de Compra:&nbsp;&nbsp;</b> {numero}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Total Adudicado en Bs:&nbsp;&nbsp;</b> {total_adjudicado_mb}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Funcionario de Contacto:&nbsp;&nbsp;</b> {funcionario_contacto}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Usuario Registro:&nbsp;&nbsp;</b> {usr_reg}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Notificación Orden de compra:&nbsp;&nbsp;</b> {correo_oc}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Obs:&nbsp;&nbsp;</b> {obs}</p><br>'
	        )
    }),
    arrayDefaultColumHidden:['id_fecha_reg','id_fecha_mod',
'fecha_mod','usr_reg','usr_mod','numero',
'total_adjudicado_mb','tipo_cambio_conv','lugar_entrega','forma_pago','tipo_entrega','tiempo_entrega',
'fecha_venc','fecha_entrega','obs','fecha_adju', 'nro_contrato','funcionario_contacto',
'telefono_contacto','correo_contacto','prellenar_oferta','estado_reg','fecha_reg','usr_reg','fecha_mod','usr_mod'],
	sortInfo:{
		field: 'id_cotizacion',
		direction: 'ASC'
	},
	
	onButtonCartaAdj: function(){
                var rec=this.sm.getSelected();
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Cotizacion/reporteCartaAdjudicacion',
                    params: {'id_proceso_wf':rec.data.id_proceso_wf},
                    success: this.successExport,
                    failure: function() {
                        alert("fail");
                    },
                    timeout: function() {
                        alert("timeout");
                    },
                    scope:this
                });
        },
	
	onButtonRepOC: function(){
		
		        var rec=this.sm.getSelected();
                if (rec.data.requiere_contrato == 'no'){
	                 //si no tiene numero de orden compra generamos 
	                if(!rec.data.numero_oc || rec.data.numero_oc == '' || rec.data.numero_oc == 'S/N'){
		                Phx.CP.loadingShow();
		                Ext.Ajax.request({
		                    url:'../../sis_adquisiciones/control/Cotizacion/generarNumOC',
		                    params:{'id_cotizacion':rec.data.id_cotizacion},
		                    success: function(resp){
		                    	Phx.CP.loadingHide();
					            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
					            if(!reg.ROOT.error){
					                 this.mostrarReporteOC(rec.data);
					             }
					             else{
					                 alert('error al generar número de OC');
		                         }
		                    	
		                    },
		                    failure: function() {
		                    	Phx.CP.loadingHide();
		                        alert('error al generar número de OC');
		                    },
		                    timeout: function() {
		                    	Phx.CP.loadingHide();
		                        alert("timeout");
		                    },
		                    scope: this
		                });	
	                }
	                else{
	                	 this.mostrarReporteOC(rec.data);
	                }
	                	
                }
                else{
                	alert('Esta cotizaicón no genera OC por que esta marcada para tener contrato');
                	return;
                }
               
                
                
                
               
        },
      
      mostrarReporteOC: function(data){
  	        Ext.Ajax.request({
                url: '../../sis_adquisiciones/control/Cotizacion/reporteOC',
                params: { 'id_cotizacion': data.id_cotizacion, 'id_proveedor': data.id_proveedor },
                success: this.successExport,
                failure: function() {
                	Phx.CP.loadingHide();
                    alert("fail");
                },
                timeout: function() {
                    alert("timeout");
                },
                scope:this
            });
      },
      
      onButtonReporte:function(){
            var rec=this.sm.getSelected();
            Ext.Ajax.request({
                url:'../../sis_adquisiciones/control/Cotizacion/reporteCotizacion',
                params:{'id_cotizacion':rec.data.id_cotizacion,'tipo':rec.data.estado},
                success: this.successExport,
                failure: function() {
                    alert("fail");
                },
                timeout: function() {
                    alert("timeout");
                },
                scope:this
            });  
	},
    
 
	
	 loadCheckDocumentosSolWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            rec.data.check_fisico = 'si';
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                   
                    this.idContenedor,
                    'DocumentoWf'
        )
    },
    
    successSimple:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                 this.reload();
             }
             else{
                alert('ocurrio un error durante el proceso')
            }
     },
     
      preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.CotizacionOC.superclass.preparaMenu.call(this,n);
          this.menuAdq.enable();
          this.getBoton('btnReporte').enable();
          this.getBoton('btnRepOC').enable(); 
          this.getBoton('diagrama_gantt').enable();
          this.getBoton('btnChequeoDocumentosWf').enable();
          return tb 
     }, 
     
	  liberaMenu:function() {
        var tb = Phx.vista.CotizacionOC.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('btnReporte').disable();
            this.getBoton('btnRepOC').disable(); 
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.menuAdq.disable();
         }
       return tb
    },
    
	bdel:false,
	bnew:false,
	bedit:false,
	bsave:false,
	south:{	   
        url:'../../../sis_adquisiciones/vista/cotizacion_det/CotizacionDet.php',
        title:'Detalles Cotizacion', 
        height : '50%',
        cls:'CotizacionDet'},
    onReloadPage:function(param){

        var me = this;
        this.initFiltro(param);
    },

    initFiltro: function(param){
        this.store.baseParams=param;
        this.load( { params: { start:0, limit: this.tam_pag } });
    },
	}
)
</script>