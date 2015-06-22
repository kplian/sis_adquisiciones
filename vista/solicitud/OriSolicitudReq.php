<?php
/**
*@package pXP
*@file gen-SolicitudReq.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@Interface para el inicio de solicitudes de compra
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudReq = {
	require:'../../../sis_adquisiciones/vista/solicitud/Solicitud.php',
	requireclase:'Phx.vista.Solicitud',
	title:'Solicitud',
	nombreVista: 'solicitudReq',
	//layoutType: 'wizard',
	
	constructor: function(config) {
    		Phx.vista.SolicitudReq.superclass.constructor.call(this,config);
    		this.addButton('fin_requerimiento',{ text:'Finalizar', iconCls: 'badelante', disabled: true, handler: this.fin_requerimiento, tooltip: '<b>Finalizar</b>'});
            this.addButton('btnSolpre',{ text:'Sol Pre.',iconCls: 'bemail', disabled: true, handler: this.onSolModPresupuesto, tooltip: '<b>Solicitar Presuuesto</b><p>Emite un correo para solicitar traspaso presupuestario</p>'});
       
        
            this.iniciarEventos();
            
            //agrega ventana para selecion de RPC
            
                
            this.formRPC = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
           
            layout: 'form',
              
           
    
            items: [{
                    xtype: 'combo',
                    name: 'id_funcionario_rpc',
                     hiddenName: 'id_funcionario_rpc',
                    fieldLabel: 'RPC',
                    allowBlank: false,
                    emptyText:'Elija un funcionario',
                    store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_parametros/control/Aprobador/listarAprobadorFiltrado',
                        id: 'id_funcionario',
                        root:'datos',
                        sortInfo:{
                            field:'prioridad',
                            direction:'ASC'
                        },
                        totalProperty:'total',
                        fields: ['id_funcionario','desc_funcionario','prioridad'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'desc_funcionario'}
                    }),
                    valueField: 'id_funcionario',
                    displayField: 'desc_funcionario',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    width:210,
                    gwidth:220,
                    listWidth:'280',
                    minChars:2,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_funcionario}</p>Prioridad: <strong>{prioridad}</strong> </div></tpl>'
                
                }]
        });
        
        
         this.cmbRPC =this.formRPC.getForm().findField('id_funcionario_rpc');
         this.cmbRPC.store.on('exception', this.conexionFailure);
         this.cmbRPC.store.baseParams.codigo_subsistema='ADQ';
         
         
         
         this.wRPC = new Ext.Window({
            title: 'RPC',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 350,
            height: 200,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formRPC,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.onFinalizarSol,
                scope:this
                
            },{
                text: 'Cancelar',
                handler:function(){this.wRPC.hide()},
                scope:this
            }]
        });
            
		
		
		this.store.baseParams={tipo_interfaz:this.nombreVista};
		if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
		this.load({params:{start:0, limit:this.tam_pag}});
		
		
	},
    
    iniciarEventos:function(){
        
        this.cmpFechaSoli = this.getComponente('fecha_soli');
        this.cmpIdDepto = this.getComponente('id_depto');
        this.cmpIdGestion = this.getComponente('id_gestion');
     
        //inicio de eventos 
        this.cmpFechaSoli.on('change',function(f){
        	
             this.obtenerGestion(this.cmpFechaSoli);
             this.Cmp.id_funcionario.enable();             
             this.Cmp.id_funcionario.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
             
             },this);
        
        
           
           this.Cmp.tipo.on('select',function(cmp,rec){
               console.log('rec..',rec)
               if(rec.json[0]=='Bien - Servicio'){
                   
                  this.Cmp.tipo_concepto.store.loadData(this.arrayStore['Bien'].concat(this.arrayStore['Servicio']));
               }
               else{
                   this.Cmp.tipo_concepto.store.loadData(this.arrayStore[rec.json[0]]);
               }
                if(rec.json[0] == 'Bien' ||  rec.json[0] == 'Bien - Servicio'){
                	this.Cmp.lugar_entrega.setValue('Almacenes de Oficina Cochabamba');
                	this.ocultarComponente(this.Cmp.fecha_inicio);
                	this.Cmp.dias_plazo_entrega.allowBlank = false;
                	
                	
                	
                 }
                else{
                	this.Cmp.lugar_entrega.setValue('');
                	this.mostrarComponente(this.Cmp.fecha_inicio);
                	this.Cmp.dias_plazo_entrega.allowBlank = true;
                }
                this.mostrarComponente(this.Cmp.dias_plazo_entrega);
              
           },this);
           
           this.Cmp.id_funcionario.on('select',function(rec){ 
        	
        	//Aprobador  
            this.cmpIdFuncionarioAprobador.store.baseParams.id_funcionario_dependiente=this.Cmp.id_funcionario.getValue();
            this.cmpIdFuncionarioAprobador.store.baseParams.gerencia='si';
            this.cmpIdFuncionarioAprobador.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
            this.cmpIdFuncionarioAprobador.modificado=true;
            
            //Supervisor  
            this.Cmp.id_funcionario_supervisor.store.baseParams.id_funcionario_dependiente=this.Cmp.id_funcionario.getValue();
            this.Cmp.id_funcionario_supervisor.store.baseParams.presupuesto='todos';  //no se filtar solo las unidades que presupeustan
            this.Cmp.id_funcionario_supervisor.store.baseParams.gerencia='no';  //no se aplica el filtro de gerencia de area
            this.Cmp.id_funcionario_supervisor.store.baseParams.filter_rpc='si'; //se excluye a los rpc de esta lista
            this.Cmp.id_funcionario_supervisor.store.baseParams.lista_blanca='4'; //solo se lista jefes de departamento
            
            this.Cmp.id_funcionario_supervisor.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
            this.Cmp.id_funcionario_supervisor.modificado=true;
            
            
            
            //Unidad
            this.Cmp.id_uo.store.baseParams.id_funcionario_uo_presupuesta=this.Cmp.id_funcionario.getValue();
            this.Cmp.id_uo.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
            this.Cmp.id_uo.store.load({params:{start:0,limit:this.tam_pag}, 
		       callback : function (r) {	       				
		    		if (r.length > 0 ) {	       				
	    				this.Cmp.id_uo.setValue(r[0].data.id_uo);
	    			}     
		    			    		
		    	}, scope : this
		    });
            
            this.cmpIdUo.enable();
            this.cmpIdFuncionarioAprobador.reset();
            this.cmpIdFuncionarioAprobador.enable();
            this.Cmp.id_funcionario_supervisor.reset();
            this.Cmp.id_funcionario_supervisor.enable();
            
           },this);
      
    },
         
    onButtonNew:function(){
       Phx.vista.SolicitudReq.superclass.onButtonNew.call(this); 
       
       this.cmpIdDepto.enable(); 
       this.Cmp.id_categoria_compra.enable();
       
       this.Cmp.id_funcionario.disable();
       this.Cmp.fecha_soli.enable();
       this.Cmp.fecha_soli.setValue(new Date());
       this.Cmp.fecha_soli.fireEvent('change');
       
       this.Cmp.tipo.enable();
       this.Cmp.tipo_concepto.enable();
       this.Cmp.id_moneda.enable();
       
       
       this.Cmp.id_categoria_compra.store.load({params:{start:0,limit:this.tam_pag}, 
	       callback : function (r) {
	       		if (r.length == 1 ) {	       				
	    			this.Cmp.id_categoria_compra.setValue(r[0].data.id_categoria_compra);
	    		}    
	    			    		
	    	}, scope : this
	    });
	    
	    
	    this.Cmp.id_depto.store.load({params:{start:0,limit:this.tam_pag}, 
           callback : function (r) {
                if (r.length == 1 ) {                       
                    this.Cmp.id_depto.setValue(r[0].data.id_depto);
                }    
                                
            }, scope : this
        });
	    
	    
	    this.Cmp.id_funcionario.store.load({params:{start:0,limit:this.tam_pag}, 
	       callback : function (r) {
	       		if (r.length == 1 ) {	       				
	    			this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
	    			this.Cmp.id_funcionario.fireEvent('select', r[0]);
	    		}    
	    			    		
	    	}, scope : this
	    });
	    
	    
		
           
    },
    onButtonEdit:function(){
       this.cmpFechaSoli.disable();
       this.cmpIdDepto.disable();        
       this.Cmp.id_categoria_compra.disable();
      
       this.Cmp.tipo.disable();
       this.Cmp.tipo_concepto.disable();
       this.Cmp.id_moneda.disable();
       
       Phx.vista.SolicitudReq.superclass.onButtonEdit.call(this);
       this.Cmp.id_funcionario.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
       //this.Cmp.fecha_soli.fireEvent('change');  
       
           if(this.Cmp.tipo.getValue() == 'Bien' ||  this.Cmp.tipo.getValue() == 'Bien - Servicio'){
                	this.ocultarComponente(this.Cmp.fecha_inicio);
                	this.Cmp.dias_plazo_entrega.allowBlank = false;
            }
            else{
            	this.mostrarComponente(this.Cmp.fecha_inicio);
            	this.Cmp.dias_plazo_entrega.allowBlank = true;
            }
            this.mostrarComponente(this.Cmp.dias_plazo_entrega);
    },
    
    onFinalizarSol:function(){
           var d= this.sm.getSelected().data;
         
          if(this.formRPC.getForm().isValid()){ 
                   Phx.CP.loadingShow(); 
                   Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_adquisiciones/control/Solicitud/finalizarSolicitud',
                    params: { id_solicitud: d.id_solicitud, operacion:'finalizar', id_estado_wf: d.id_estado_wf, id_funcionario_rpc: this.cmbRPC.getValue() },
                    success: this.successFinSol,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                }); 
            } 
     },
    
    successFinSol:function(resp){
            
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
                this.reload();
                 this.wRPC.hide ();
               
            }else{
                
                alert('ocurrio un error durante el proceso')
            }
           
            
        },
    
    
       fin_requerimiento:function()
        {                   
            var d= this.sm.getSelected().data;
           
            Phx.CP.loadingShow();
            this.cmbRPC.reset();
            
            this.cmbRPC.store.baseParams.id_uo=d.id_uo;
            this.cmbRPC.store.baseParams.fecha=d.fecha_soli;
            this.cmbRPC.store.baseParams.id_proceso_macro=d.id_proceso_macro;
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Solicitud/finalizarSolicitud',
                params: { id_solicitud: d.id_solicitud, operacion:'verificar', id_estado_wf: d.id_estado_wf },
                success: this.successSinc,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });     
        },
       successSinc:function(resp){
            
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
               
               //RAC 29/1/2014
               //comentado par ano msotrar el formualrio de RPC
               //y que funcone la seleccion automtica
               // si en un futuro es requerido regresar es solo descomentar
                 /*
                 this.cmbRPC.store.baseParams.monto= reg.ROOT.datos.total;
                 this.cmbRPC.modificado=true;
                 this.wRPC.show();
                */
               
                 this.reload();
            }else{
                
                alert('ocurrio un error durante el proceso')
            }
           
            
        },
     
     obtenerGestion:function(x){
         
         var fecha = x.getValue().dateFormat(x.format);
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
                    params:{fecha:fecha},
                    success:this.successGestion,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
             });
        }, 
    successGestion:function(resp){
       Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
                this.cmpIdGestion.setValue(reg.ROOT.datos.id_gestion);
                
               
            }else{
                
                alert('ocurrio al obtener la gestion')
            } 
    },
    
  
    
	 preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.SolicitudReq.superclass.preparaMenu.call(this,n);  
      //habilitar reporte de colicitud de comrpa y preorden de compra
      this.menuAdq.enable();    
      if(data['estado']==  'borrador' || data['estado']==  'Borrador'){
         this.getBoton('fin_requerimiento').enable();
         
       }
       else{
           this.getBoton('fin_requerimiento').disable();
           this.getBoton('edit').disable();
           //this.getBoton('new').disable();
           this.getBoton('del').disable();
          // this.getBoton('save').disable();
        
          
          
        }
        
        if(data.estado =='borrador' || data.estado =='pendiente' ||data.estado =='vbgerencia'){ 
          this.getBoton('btnSolpre').enable(); 
        }
        else{
           this.getBoton('btnSolpre').disable();     
        }
          
          
        return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.SolicitudReq.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('fin_requerimiento').disable();
            this.getBoton('btnSolpre').disable(); 
            this.menuAdq.disable();
        }
        
       return tb
    },    
       
	
	south:
          { 
          url:'../../../sis_adquisiciones/vista/solicitud_det/SolicitudReqDet.php',
          title:'Detalle', 
          height:'50%',
          cls:'SolicitudReqDet'
         }
};
</script>
