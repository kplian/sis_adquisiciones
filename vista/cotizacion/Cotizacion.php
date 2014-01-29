<?php
/**
*@package pXP
*@file Cotizacion.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-03-2013 14:48:35
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Cotizacion=Ext.extend(Phx.gridInterfaz,{
    tam_pag:50,
	constructor:function(config){
	    
	    this.maestro=config;
		//llama al constructor de la clase padre
    	Phx.vista.Cotizacion.superclass.constructor.call(this,config);
    	
    	//RAC: Se agrega menú de reportes de adquisiciones
        this.addBotones();
    	
         this.addButton('ant_estado',{
              argument: {estado: 'anterior'},
              text:'Anterior',
              iconCls: 'batras',
              disabled:true,
              handler:this.antEstado,
              tooltip: '<b>Pasar al Anterior Estado</b>'
          });
          
          this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Docs',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );
          
          this.Cmp.id_moneda.store.baseParams.id_moneda = this.maestro.id_moneda;
								
		 
    },
    
    addBotones: function() {
        console.log('add botones','b-btnRepOC-' + this.idContenedor)
        this.menuAdq = new Ext.Toolbar.SplitButton({
            id: 'btn-adq-' + this.idContenedor,
            text: 'Rep.',
            disabled: true,
            iconCls : 'bpdf32',
            scope: this,
            menu:{
            items: [{
                id:'b-btnReporte-' + this.idContenedor,
                text: 'Cotización',
                tooltip: '<b>Reporte de  Cotización</b>',
                handler:this.onButtonReporte,
                scope: this
            }, {
                id:'b-btnRepOC-' + this.idContenedor,
                text: 'Cuadro Comparativo',
                tooltip: '<b>Reporte de Orden de Compra</b>',
                handler:this.onButtonRepOC,
                scope: this
            }
        ]}
        });
        
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
                name: 'estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 90,
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
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'cot.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },		
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
	    					fields: ['id_proveedor','codigo','desc_proveedor'],
	    					// turn on remote sorting
	    					remoteSort: true,
	    					baseParams:{par_filtro:'codigo#desc_proveedor'}
	    				}),
        	    valueField: 'id_proveedor',
        	    displayField: 'desc_proveedor',
        	    gdisplayField: 'desc_proveedor',
        	    hiddenName: 'id_proveedor',
        	    triggerAction: 'all',
        	    //queryDelay:1000,
        	    pageSize:10,
				forceSelection: true,
				typeAhead: true,
				allowBlank: false,
				anchor: '80%',
				gwidth: 150,
				mode: 'remote',
				renderer: function(value,p,record){
                        if(record.data.estado=='anulado'){
                             return String.format('<b><font color="red">{0}</font></b>', record.data['desc_proveedor']);
                         }
                        else if(record.data.estado=='adjudicado'){
                             return String.format('<b><font color="green">{0}</font></b>', record.data['desc_proveedor']);
                        }
                        else{
                            return String.format('{0}', record.data['desc_proveedor']);
                        }}
			},
	           			
			type:'ComboBox',
			filters:{pfiltro:'pro.desc_proveedor',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
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
                             return String.format('<b><font color="green">{0}</font></b>', value);
                         
                        
                        }
                        else{
                            return String.format('{0}', value);
                        }},
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'sol.numero',type:'string'},
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
            filters:{pfiltro:'cot.numero_oc',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
          {
            config:{
                name: 'fecha_coti',
                fieldLabel: 'Fecha Cotiz.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'cot.fecha_coti',type:'date'},
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
                pfiltro:'mon.moneda#mon.codigo',
                type:'string'
            },
            grid:true,
            form:true
          },
           {
            config:{
                name: 'tipo_cambio_conv',
                fieldLabel: 'Tipo de Cambio',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100
            },
            type:'NumberField',
            filters:{pfiltro:'cot.tipo_cambio_conv',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'lugar_entrega',
				fieldLabel: 'Lugar Entrega',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextField',
			filters:{pfiltro:'cot.lugar_entrega',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'tipo_entrega',
				fieldLabel: 'Tipo Entrega',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:40
			},
			type:'TextField',
			filters:{pfiltro:'cot.tipo_entrega',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'fecha_venc',
				fieldLabel: 'Fecha Venc',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'cot.fecha_venc',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'obs',
				fieldLabel: 'Obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:100
			},
			type:'TextArea',
			filters:{pfiltro:'cot.obs',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
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
			filters:{pfiltro:'cot.fecha_adju',type:'date'},
			id_grupo:1,
			grid:true,
			form:true
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
			filters:{pfiltro:'cot.nro_contrato',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
    
        {
            config:{
                name: 'fecha_entrega',
                fieldLabel: 'Fecha Entrega/Inicio',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'cot.fecha_entrega',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
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
			filters:{pfiltro:'cot.estado_reg',type:'string'},
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
			filters:{pfiltro:'cot.fecha_reg',type:'date'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'cot.fecha_mod',type:'date'},
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
	
	title:'Cotizaciones',
	ActSave:'../../sis_adquisiciones/control/Cotizacion/insertarCotizacion',
	ActDel:'../../sis_adquisiciones/control/Cotizacion/eliminarCotizacion',
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
		{name:'usr_mod', type: 'string'},'email','desc_moneda','tipo_cambio_conv','id_estado_wf','id_proceso_wf','numero','num_tramite',
		{name:'id_obligacion_pago', type: 'numeric'}
		
	],

	sortInfo:{
		field: 'id_cotizacion',
		direction: 'ASC'
	},
	
	onButtonRepOC: function(){
                var rec=this.sm.getSelected();
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Cotizacion/reporteOC',
                    params:{'id_cotizacion':rec.data.id_cotizacion,'id_proveedor':rec.data.id_proveedor},
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
     antEstado:function(res,eve)
        {                   
            var d= this.sm.getSelected().data;
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            operacion=  res.argument.estado == 'inicio'?'inicio':operacion; 
            
            Ext.Ajax.request({
                url:'../../sis_adquisiciones/control/Cotizacion/anteriorEstadoCotizacion',
                params:{id_cotizacion:d.id_cotizacion, 
                        id_estado_wf:d.id_estado_wf, 
                        operacion: operacion},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
        }, 
        
         successSinc:function(resp){
            Phx.CP.loadingHide();
           
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
              
                this.reload();
             }else{
                alert('ocurrio un error durante el proceso')
            }
        },
	
	 loadCheckDocumentosSolWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Chequear documento del WF',
                    {
                        width:700,
                        height:450
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
        )
    },
	
	bdel:true,
	bsave:false,
	south:{	   
        url:'../../../sis_adquisiciones/vista/cotizacion_det/CotizacionDet.php',
        title:'Detalles Cotizacion', 
        height : '50%',
        cls:'CotizacionDet'}
	}
)
</script>
		
		