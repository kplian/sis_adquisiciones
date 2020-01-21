<?php
/**
*@package pXP
*@file CotizacionDet.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-03-2013 21:44:43
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * 
   HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               21-03-2013        RAC KPLIAN        Creación
 #16              20/01/2020        RAC KPLIAN       fix bug nombre de clase
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CotizacionDet=Ext.extend(Phx.gridInterfaz,{
    bnew:false,
    adq_tolerancia_adjudicacion: 0,
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.CotizacionDet.superclass.constructor.call(this,config);
		
		this.init();
		this.iniciarEventos();
		this.bloquearMenus();
		this.obtenerVariableGlobal('adq_tolerancia_adjudicacion');
		//this.load({params:{start:0, limit:this.tam_pag}})
		
		this.addButton('adjudicar_det',{text:'Recomendar Item',iconCls: 'bchecklist',disabled:true,handler:this.adjudicar_det,tooltip: '<b>Adjudicar</b><p>Permite adjudicar de manera parcial</p>'});
            
        
		//formulario de adjudicacion parcil
		
		this.formADJ = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
           
            layout: 'form',
              
            items: [
                   { 
                    xtype: 'numberfield',   
                    name: 'cant_sol',
                    fieldLabel: 'Cantidad Ref.',
                    minValue: 0,
                    disabled:true,
                    allowBlank: false
                    
                   },
                   { 
                    xtype: 'numberfield',   
                    name: 'catidad_cotizada',
                    fieldLabel: 'Cotizado',
                    minValue: 0,
                    disabled:true,
                    allowBlank: false
                   },
                   { 
                    xtype: 'numberfield',   
                    name: 'candidad_adj_total',
                    minValue: 0,
                    disabled:true,
                    fieldLabel: 'Total Adjudicado',
                    allowBlank: false                  
                     },
                   { 
                    xtype: 'numberfield',   
                    name: 'candidad_adj',
                    minValue: 0,
                    fieldLabel: 'Cantidad a adjudicar',
                    allowBlank: false                  
                     }
                  ]
        });
        
        
         this.cmpCS =this.formADJ.getForm().findField('cant_sol');
         this.cmpCC =this.formADJ.getForm().findField('catidad_cotizada');
         this.cmpCAT =this.formADJ.getForm().findField('candidad_adj_total');
         this.cmpCA =this.formADJ.getForm().findField('candidad_adj');
         
         
         
         this.wADJ = new Ext.Window({
            title: 'Adjudicación',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 350,
            height: 300,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formADJ,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.onAdjudicarDet,
                scope:this
                
            },{
                text: 'Cancelar',
                handler:function(){this.wADJ.hide()},
                scope:this
            }]
        });
	
	
	
	},
	adjudicar_det:function(){
	    
	    //verifica el precio unitario sea menor al precio ref en la moneda que le toca
	     var data = this.getSelectedData();
	     
	     
	     if(data.precio_unitario_mb*1 <= data.precio_unitario_mb_sol* (1+this.adq_tolerancia_adjudicacion)){
	        
	        console.log('datos....',data)
	        
	        
	        this.cmpCS.setValue(data.cantidad_sol); 
            this.cmpCC.setValue(data.cantidad_coti);
            this.cmpCA.setValue(data.cantidad_adju);
           
            Phx.CP.loadingShow();
            
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/CotizacionDet/totalAdjudicado',
                params:{id_cotizacion_det:data.id_cotizacion_det},
                success:this.preparaFormAdj,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            }); 
	    }
	    else{
	        alert("Para adjidicar el precio unitario cotizado debe ser menor o igual al precio unitario referencial, con una tolerancia de "+ (this.adq_tolerancia_adjudicacion*100)+' %');
	    }
	},
	preparaFormAdj:function(resp){
	   Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
               this.cmpCAT.setValue(reg.ROOT.datos.total_adj) ;
               this.cmpCA.setMaxValue( Math.min(this.cmpCS.getValue()-this.cmpCAT.getValue(),this.cmpCC.getValue()));
               this.wADJ.show();
            }else{
                alert('ocurrio un error durante el proceso')
            }
	},
	
	onAdjudicarDet:function(){
	  
	   if (this.formADJ.getForm().isValid()) {
    	    Phx.CP.loadingShow();
    	    var data = this.getSelectedData();
            Ext.Ajax.request({
               
                url:'../../sis_adquisiciones/control/CotizacionDet/AdjudicarDetalle',
                params:{id_cotizacion_det:data.id_cotizacion_det,cantidad_adjudicada: this.cmpCA.getValue()},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            }); 
        }
	  
	    
	    
	},
	successSinc:function(resp){
            Phx.CP.loadingHide();
           
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                this.reload();
                this.wADJ.hide();
                
             }else{
                alert('ocurrio un error durante el proceso')
            }
        },
        
	
	tam_pag:50,
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_cotizacion_det'
			},
			type:'Field',
			form:true 
		},		
		{
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
				name: 'id_solicitud_det',
				fieldLabel: 'Solicitud Det',
				allowBlank: false,
				emptyText: 'Solicitud Det...',
				store: new Ext.data.JsonStore({

	    					url: '../../sis_adquisiciones/control/SolicitudDet/listarSolicitudDetCotizacion',
	    					id: 'id_solicitud_det',
	    					root: 'datos',
	    					sortInfo:{
	    						field: 'id_solicitud_det',
	    						direction: 'ASC'
	    					},
	    					totalProperty: 'total',
	    					fields: ['id_solicitud_det','desc_centro_costo','desc_concepto_ingas','descripcion'],
	    					// turn on remote sorting
	    					remoteSort: true,
	    					baseParams:{par_filtro:'codigo'}
	    				}),
        	    valueField: 'id_solicitud_det',
        	    displayField: 'desc_concepto_ingas',
        	    gdisplayField: 'descripcion_sol',
        	    hiddenName: 'id_solicitud_det',
        	    triggerAction: 'all',
        	    //queryDelay:1000,
        	    pageSize:10,
				forceSelection: true,
				typeAhead: true,
				allowBlank: false,
				anchor: '80%',
				gwidth: 250,
				mode: 'remote',
				renderer: function(value,p,record){
				    
				     if(record.data.cantidad_adju>0){
                                                     return String.format('<b><font color="green">{0}</font></b>', record.data['desc_solicitud_det']);
                                                }
                                                else{
                                                    return String.format('{0}', record.data['desc_solicitud_det']);
                                                }
				    },
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_concepto_ingas}<br>{desc_centro_costo}</p></div></tpl>'
			},
	           			
			type:'ComboBox',
			filters:{pfiltro:'cig.desc_ingas',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
        {
            config:{
                name: 'descripcion_sol',
                fieldLabel: 'Descripcións',
                allowBlank: true,
                anchor: '80%',
                gwidth: 200,
                renderer:function (value, p, record){
                                                if(record.data.cantidad_adju>0){
                                                     return String.format('<b><font color="green">{0}</font></b>', value);
                                                }
                                                else{
                                                    return String.format('{0}', value);
                                                }
                                            
                                        },
                maxLength:700
            },
            type:'TextArea',
            filters:{pfiltro:'sold.descripcion',type:'string'},
            id_grupo:1,
            grid:true,
            egrid:true,
            form:true
        },
        {
            config:{
                name: 'cantidad_sol',
                fieldLabel: 'Cantidad Ref.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1245184
            },
            type:'NumberField',
            filters:{pfiltro:'sold.precio_unitario',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'precio_unitario_sol',
                currencyChar:' ',
                fieldLabel: 'P/U Ref.',
                allowBlank: true,
                allowDecimals: true,
                allowNegative:false,
                decimalPrecision:3,
                anchor: '80%',
                gwidth: 120,
                maxLength:1245186
            },
            type:'NumberField',
            filters:{pfiltro:'ctd.precio_unitario',type:'numeric'},
            id_grupo:1,
            grid:true,
           form:false
        },
        {
            config:{
                name: 'cantidad_coti',
                fieldLabel: 'Cant. Ofer.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:1245184
            },
            type:'NumberField',
            filters:{pfiltro:'ctd.cantidad_coti',type:'numeric'},
            id_grupo:1,
            grid:true,
            egrid:true,
            form:true
        },
		{
			config:{
				name: 'precio_unitario',
				currencyChar:' ',
				fieldLabel: 'P/U Ofer.',
				allowBlank: true,
				allowDecimals: true,
                allowNegative:false,
                decimalPrecision:4,
				anchor: '80%',
				gwidth: 120,
				maxLength:1245186
			},
			type:'NumberField',
			filters:{pfiltro:'ctd.precio_unitario',type:'numeric'},
			id_grupo:1,
			grid:true,
			egrid:true,
			form:true
		},
		{
			config:{
				name: 'cantidad_adju',
				fieldLabel: 'Cant. Adjudicada',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:1245184
			},
			type:'NumberField',
			filters:{pfiltro:'ctd.cantidad_adju',type:'numeric'},
			id_grupo:1,
			grid:true,
			form:false
		},
        {
            config:{
                name: 'revertido_mb',
                fieldLabel: 'Revertido MB',
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'Field',
            filters:{pfiltro:'sold.revertido_mb',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'obs',
				fieldLabel: 'Obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'ctd.obs',type:'string'},
			id_grupo:1,
			grid:true,
			egrid:true,
			form:true
		},
        {
            config:{
                name: 'desc_centro_costo',
                fieldLabel: 'Centro de Costos',
                allowBlank: true,
                anchor: '80%',
                gwidth: 280,
                maxLength:500
            },
            type:'Field',
            filters:{pfiltro:'cc.codigo_cc',type:'string'},
            id_grupo:1,
            grid:true,
            gedit:true,
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
			filters:{pfiltro:'ctd.estado_reg',type:'string'},
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
			filters:{pfiltro:'ctd.fecha_reg',type:'date'},
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
			filters:{pfiltro:'ctd.fecha_mod',type:'date'},
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
	
	title:'Detalle cotizacion',
	ActSave:'../../sis_adquisiciones/control/CotizacionDet/insertarCotizacionDet',
	ActDel:'../../sis_adquisiciones/control/CotizacionDet/eliminarCotizacionDet',
	ActList:'../../sis_adquisiciones/control/CotizacionDet/listarCotizacionDet',
	id_store:'id_cotizacion_det',
	fields: [
		{name:'id_cotizacion_det', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_cotizacion', type: 'numeric'},
		{name:'precio_unitario', type: 'numeric'},
		{name:'cantidad_adju', type: 'numeric'},
		{name:'cantidad_coti', type: 'numeric'},
		{name:'obs', type: 'string'},
		{name:'id_solicitud_det', type: 'numeric'},
		{name:'desc_solicitud_det', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'desc_centro_costo',
        'cantidad_sol',
        'precio_unitario_sol','revertido_mb','revertido_mo',
        'descripcion_sol',
        'precio_unitario_mb_sol','precio_unitario_mb'],
	sortInfo:{
		field: 'id_cotizacion_det',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	
	iniciarEventos:function(){
	    
	    this.cmpPrecioUnitario=this.getComponente('precio_unitario');
	    
	    
        this.cmbSolicitudDet=this.getComponente('id_solicitud_det');
        
         this.cmpDescripcionSol=this.getComponente('descripcion_sol');
         //this.cmpDescripcionSol.disable();
       
         
          this.cmbSolicitudDet.on('select',function(c,d){
               
               this.cmpDescripcionSol.setValue(d.data.descripcion);
          },this);
	    
	    
	    this.confPrecioUnitarioSol = this.Atributos[this.getIndAtributo('precio_unitario_sol')].config;
	   
	    
	    
	    
	    
	},
	 preparaMenu:function(n){
	      var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.CotizacionDet.superclass.preparaMenu.call(this,n);  
              
              if(this.maestro.estado ==  'cotizado'){
                 this.getBoton('adjudicar_det').enable();
                 
               }
              else{
                   this.getBoton('adjudicar_det').disable();
               }
            
            if(this.maestro.estado ==  'borrador'){ 
                
                this.getBoton('edit').enable();
                //this.getBoton('new').enable();
                this.getBoton('del').enable();
                this.getBoton('save').enable();
             } 
             else{
                 
                this.getBoton('edit').disable();
               // this.getBoton('new').disable();
                this.getBoton('del').disable();
                this.getBoton('save').disable(); 
                 
             }
               
               
            return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.CotizacionDet.superclass.liberaMenu.call(this);
        if(tb){
             
            this.getBoton('adjudicar_det').disable();
            
            if(this.maestro&&this.maestro.estado !=  'borrador'){ 
                this.getBoton('edit').disable();
                //this.getBoton('new').disable();
                this.getBoton('del').disable();
                this.getBoton('save').disable();
             } 
        }
       return tb
    }, 
    
	
	onReloadPage:function(m){       
        this.maestro=m;
        this.Atributos[1].valorInicial=this.maestro.id_cotizacion;
        
        //coloca el id_cotizacion al atributo id_solicitud_det
        this.getComponente('id_solicitud_det').store.baseParams.id_cotizacion=this.maestro.id_cotizacion;
        this.getComponente('id_solicitud_det').disable();
        
        this.store.baseParams={id_cotizacion:this.maestro.id_cotizacion};        
        this.load({params:{start:0, limit:50}})       
       
       
        this.cmpPrecioUnitario.currencyChar = this.maestro.desc_moneda+' ';
        this.setColumnHeader('precio_unitario', '(e)'+this.cmpPrecioUnitario.fieldLabel +' '+this.maestro.desc_moneda)
       
        this.setColumnHeader('precio_unitario_sol',   this.confPrecioUnitarioSol.fieldLabel +' '+this.maestro.desc_moneda_sol)
       
       if(this.maestro.estado ==  'borrador'){
             
             //this.getBoton('new').enable();
             
         }
         else{
             
             this.getBoton('edit').disable();
             //this.getBoton('new').disable();
             this.getBoton('del').disable();
             this.getBoton('save').disable();
          }
       
     },
     
     obtenerVariableGlobal: function(param){				
				//Verifica que la fecha y la moneda hayan sido elegidos
				Phx.CP.loadingShow();
				Ext.Ajax.request({
						url:'../../sis_seguridad/control/Subsistema/obtenerVariableGlobal',
						params:{
							codigo: param  
						},
						success: function(resp){
							Phx.CP.loadingHide();
							var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
							
							if (reg.ROOT.error) {
								Ext.Msg.alert('Error','Error a recuperar la variable global')
							} else {
								if (param == 'adq_tolerancia_adjudicacion'){									  
									  this.adq_tolerancia_adjudicacion = reg.ROOT.datos.valor*1;									  
								}
								
							}
						},
						failure: this.conexionFailure,
						timeout: this.timeout,
						scope:this
					});
		
	  }
		
})
</script>
		
		