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

	constructor:function(config){
		this.maestro=config.maestro;
		//llama al constructor de la clase padre
    	Phx.vista.Cotizacion.superclass.constructor.call(this,config);
								
									 this.addButton('btnReporte',{
                    text :'Reporte',
                    iconCls : 'bpdf32',
                    disabled: true,
                    handler : this.onButtonReporte,
                    tooltip : '<b>Reporte de Cotizacion</b><br/><b>Cotizacion de solicitud de Compra</b>'
          });
          
          this.addButton('btnRepOC',{
            text :'Orden de Compra',
            iconCls : 'bpdf32',
            disabled: true,
            handler : this.onButtonRepOC,
            tooltip : '<b>Orden de Compra</b><br/><b>Orden de Compra</b>'
	 							 });
       
         this.addButton('ant_estado',{
              argument: {estado: 'anterior'},
              text:'Anterior',
              iconCls: 'batras',
              disabled:true,
              handler:this.antEstado,
              tooltip: '<b>Pasar al Anterior Estado</b>'
          });
         
		
		 this.addButton('fin_registro',{text:'Fin Reg.',iconCls: 'badelante',disabled:true,handler:this.fin_registro,tooltip: '<b>Finalizar</b><p>Finalizar registro de cotización</p>'});
         
         this.addButton('btnAdjudicar',{
                    text :'Adjudicar',
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onAdjudicarTodo,
                    tooltip : '<b>Adjudicar Todo</b><br/><b>Adjudica todo lo disponible</b>'
          });   
		
		this.addButton('btnGenOC',{
                    text :'Generar OC',
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onGenOC,
                    tooltip : '<b>Genrar OC</b><br/><b>Genera el Número de Orden de Compra</b>'
          });
		
		this.addButton('btnHabPago',{
                    text :'Habilitar Pago',
                    iconCls : 'bcharge',
                    disabled: true,
                    handler : this.onHabPag,
                    tooltip : '<b>Habilitar Pago</b><br/><b> Permite solicitar pagos en el modulo de cuentar por pagar</b>'
          });
		
		this.init();
		this.iniciarEventos();
		this.store.baseParams={id_proceso_compra:this.id_proceso_compra}; 
		this.load({params:{start:0, limit:this.tam_pag}});
		
		//formulario de adjudicacion parcil
        
        this.formOC = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
            layout: 'form',
            items: [
                   { 
                    xtype: 'datefield',   
                    name: 'fecha_oc',
                    fieldLabel: 'Fecha OC',
                    disabled:true,
                    allowBlank: false
                    
                   }
                  ]
        });
        
        
         this.cmpFechaOC =this.formOC.getForm().findField('fecha_oc');
         
         
         
         this.wOC= new Ext.Window({
            title: 'Generar OC',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 350,
            height: 170,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formOC,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.onSubmitGenOC,
                scope:this
                
            },{
                text: 'Cancelar',
                handler:function(){this.wOC.hide()},
                scope:this
            }]
        });
        
        //formulario de departamentos
        
        this.formDEPTO = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
            layout: 'form',
            items: [
                   {
                    xtype: 'combo',
                    name: 'id_depto_tes',
                     hiddenName: 'id_depto_tes',
                    fieldLabel: 'DEP TESORERIA',
                    allowBlank: false,
                    emptyText:'Elija un Depto',
                    store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_parametros/control/Depto/listarDepto',
                        id: 'id_depto',
                        root: 'datos',
                        sortInfo:{
                            field: 'deppto.nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_depto','nombre'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'deppto.nombre#deppto.codigo',estado:'activo',codigo_subsistema:'TES',tipo_filtro:'DEP_EP-DEP_EP'}
                    }),
                    valueField: 'id_depto',
                    displayField: 'nombre',
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p></div></tpl>',
                    hiddenName: 'id_depto_tes',
                    forceSelection:true,
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:10,
                    queryDelay:1000,
                    width:250,
                    listWidth:'280',
                    minChars:2
                }
                  ]
        });
        
        this.cmpDeptoTes =this.formDEPTO.getForm().findField('id_depto_tes');
        
        this.wDEPTO= new Ext.Window({
            title: 'Depto Tesoreria',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 400,
            height: 200,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formDEPTO,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.onSubmitHabPag,
                scope:this
                
            },{
                text: 'Cancelar',
                handler:function(){this.wDEPTO.hide()},
                scope:this
            }]
        });
    },
	tam_pag:50,
			
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
            type:'NumberField',
            filters:{pfiltro:'cot.numero_oc',type:'numeric'},
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
		{name:'usr_mod', type: 'string'},'desc_moneda','tipo_cambio_conv','id_estado_wf','id_proceso_wf'
		
	],
	
	onButtonReporte:function(){
	    var rec=this.sm.getSelected();
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Cotizacion/reporteCotizacion',
                    params:{'id_cotizacion':rec.data.id_cotizacion,'tipo':rec.data.estado},
                    success: this.successExport,
                    failure: function() {
                        console.log("fail");
                    },
                    timeout: function() {
                        console.log("timeout");
                    },
                    scope:this
                });  
	},

	sortInfo:{
		field: 'id_cotizacion',
		direction: 'ASC'
	},
	
	EnableSelect:function(n){
	     Phx.vista.Cotizacion.superclass.EnableSelect.call(this,n,{desc_moneda_sol:this.desc_moneda});
	},
	
	onButtonNew:function(){			
			Phx.vista.Cotizacion.superclass.onButtonNew.call(this);
			
			this.cmbMoneda.disable();
            this.cmpTipoCambioConv.disable();
         
			this.getComponente('id_proceso_compra').setValue(this.id_proceso_compra);			
	},
	

	
	iniciarEventos:function(){
    	  this.cmbMoneda= this.getComponente('id_moneda');
    	  this.cmpFechaCoti =  this.getComponente('fecha_coti');
    	  this.cmpTipoCambioConv =  this.getComponente('tipo_cambio_conv');
    	  this.cmbMoneda.disable();
    	  this.cmpTipoCambioConv.disable();
    	  
    	  this.cmpFechaCoti.on('blur',function(){
    	       this.cmbMoneda.enable();
    	       this.cmbMoneda.reset();
    	       this.cmpTipoCambioConv.reset();
    	       
    	  },this);
    	 
    	  this.cmbMoneda.on('select',function(com,dat){
    	      
    	      if(dat.data.tipo_moneda=='base'){
    	         this.cmpTipoCambioConv.disable();
    	         this.cmpTipoCambioConv.setValue(1); 
    	          
    	      }
    	      else{
    	           this.cmpTipoCambioConv.enable()
    	         this.obtenerTipoCambio();  
    	      }
    	     
    	      
    	  },this);
	   
	},
	obtenerTipoCambio:function(){
         
         var fecha = this.cmpFechaCoti.getValue().dateFormat(this.cmpFechaCoti.format);
         var id_moneda = this.cmbMoneda.getValue();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_parametros/control/TipoCambio/obtenerTipoCambio',
                    params:{fecha:fecha,id_moneda:id_moneda},
                    success:this.successTC,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
             });
        }, 
    successTC:function(resp){
       Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
                this.cmpTipoCambioConv.setValue(reg.ROOT.datos.tipo_cambio);
            }else{
                
                alert('ocurrio al obtener el tipo de Cambio')
            } 
    },
	fin_registro:function()
        {                   
            var d= this.sm.getSelected().data;
           
            Phx.CP.loadingShow();
            
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Cotizacion/finalizarRegistro',
                params:{id_cotizacion:d.id_cotizacion,operacion:'fin_registro'},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
        },
     
        
         onAdjudicarTodo:function(){
            var data = this.getSelectedData();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Cotizacion/adjudicarTodo',
                params:{id_cotizacion:data.id_cotizacion},
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
                 this.wOC.hide(); 
                 this.wDEPTO.hide();
                this.reload();
             }else{
                alert('ocurrio un error durante el proceso')
            }
        },
        
        onGenOC:function(){
            
          this.cmpFechaOC.setValue(new Date());
          this.cmpFechaOC.disable();
          this.wOC.show(); 
            
        },
        

        onButtonRepOC: function(){
		   							var rec=this.sm.getSelected();
                console.debug(rec);
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Cotizacion/reporteOC',
                    params:{'id_cotizacion':rec.data.id_cotizacion},
                    success: this.successExport,
                    failure: function() {
                        console.log("fail");
                    },
                    timeout: function() {
                        console.log("timeout");
                    },
                    scope:this
                });
								},
								

        onHabPag:function(){
            console.log(this.id_depto);
            this.cmpDeptoTes.reset();
            this.cmpDeptoTes.store.baseParams.id_depto = this.id_depto;
            this.cmpDeptoTes.modificado = true;
            this.wDEPTO.show();
            
        },
        
        onSubmitHabPag:function(){
            var data = this.getSelectedData();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_adquisiciones/control/Cotizacion/habilitarPago',
                params:{id_cotizacion:data.id_cotizacion,id_depto_tes: this.cmpDeptoTes.getValue()},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        },
        

        onSubmitGenOC:function(){
            var data = this.getSelectedData();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_adquisiciones/control/Cotizacion/generarOC',
                params:{id_cotizacion:data.id_cotizacion,fecha_oc: this.cmpFechaOC.getValue().dateFormat('d/m/Y')},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
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
        
        preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.Cotizacion.superclass.preparaMenu.call(this,n); 
          this.getBoton('btnReporte').enable();

          //this.getBoton('btnReporte').enable(); 
              
              if(data['estado']==  'borrador'){
                 this.getBoton('fin_registro').enable();
                 this.getBoton('btnAdjudicar').disable();
                 this.getBoton('btnGenOC').disable();
                 this.getBoton('ant_estado').disable();
                 this.getBoton('btnRepOC').disable();
               }
              else{
                   this.getBoton('ant_estado').enable();
                   
                   if(data['estado']=='cotizado'){
                     this.getBoton('btnAdjudicar').enable();
                     this.getBoton('btnGenOC').enable();
                     this.getBoton('btnRepOC').disable();   
                   }
                   else{
                      this.getBoton('btnAdjudicar').disable(); 
                      this.getBoton('btnGenOC').disable();
                      this.getBoton('btnRepOC').enable();
                   }
                  
                   this.getBoton('fin_registro').disable();
                   this.getBoton('edit').disable();
                   this.getBoton('new').disable();
                 }
               
               if (data['estado']==  'borrador'||data['estado']=='cotizado'||data['estado']== 'adjudicado'){
                   
                    this.getBoton('del').enable();
               }
               else{
                   
                    this.getBoton('del').disable();
               }
               
               if (data['estado']==  'anulado'){
                   this.getBoton('ant_estado').disable();
                   //this.getBoton('btnReporte').disable();
                   
               }
               
                if (data['estado']!='adjudicado'){
                   this.getBoton('btnHabPago').disable();
                 }
                 else{
                    this.getBoton('btnHabPago').enable();  
                 }
               
                
            return tb 
     }, 
     
    
     
     liberaMenu:function(){
        var tb = Phx.vista.Cotizacion.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('fin_registro').disable();
            this.getBoton('btnAdjudicar').disable();
            this.getBoton('btnGenOC').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnReporte').disable();

        }
        
       return tb
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
		
		