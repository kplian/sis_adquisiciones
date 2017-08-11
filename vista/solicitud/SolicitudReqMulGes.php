<?php
/**
*@package pXP
*@file gen-SolicitudReqMulGes.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@Interface para el inicio de solicitudes de compra
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudReqMulGes = {
	require:'../../../sis_adquisiciones/vista/solicitud/Solicitud.php',
	requireclase:'Phx.vista.Solicitud',
	title:'Solicitud',
	nombreVista: 'solicitudReq',
	//layoutType: 'wizard',
	
	gruposBarraTareas:[{name:'borrador',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Borradores</h1>',grupo:0,height:0},
                       {name:'proceso',title:'<H1 align="center"><i class="fa fa-eye"></i> Iniciados</h1>',grupo:1,height:0},
                       {name:'finalizados',title:'<H1 align="center"><i class="fa fa-thumbs-o-up"></i> Finalizados</h1>',grupo:2,height:0}],
	
	actualizarSegunTab: function(name, indice){
    	if(this.finCons){
    		 this.store.baseParams.pes_estado = name;
    	     this.load({params:{start:0, limit:this.tam_pag}});
    	   }
    },
	beditGroups: [0],
    bdelGroups:  [0],
    bactGroups:  [0,1,2],
    btestGroups: [0],
    bexcelGroups: [0,1,2],
    
	constructor: function(config) {
		
		    this.Atributos[this.getIndAtributo('tipo')].form=true; 
            this.Atributos[this.getIndAtributo('tipo_concepto')].form=true; 
            this.Atributos[this.getIndAtributo('id_moneda')].form=true;
            this.Atributos[this.getIndAtributo('fecha_soli')].form=true; 
            this.Atributos[this.getIndAtributo('id_depto')].form=true; 
            this.Atributos[this.getIndAtributo('id_funcionario')].form=true;  
            this.Atributos[this.getIndAtributo('id_categoria_compra')].form=true;
            this.Atributos[this.getIndAtributo('id_proveedor')].form=true; 
            this.Atributos[this.getIndAtributo('justificacion')].form=true; 
            this.Atributos[this.getIndAtributo('lugar_entrega')].form=true; 
            this.Atributos[this.getIndAtributo('fecha_inicio')].form=true; 
            this.Atributos[this.getIndAtributo('dias_plazo_entrega')].form=true;
            
             
		
		
    		Phx.vista.SolicitudReqMulGes.superclass.constructor.call(this,config);
    		this.addButton('fin_requerimiento',{ grupo:[0],text:'Finalizar', iconCls: 'badelante', disabled: true, handler: this.fin_requerimiento, tooltip: '<b>Finalizar</b>'});
            this.addButton('btnSolpre',{ grupo:[0,],text:'Sol Pre.',iconCls: 'bemail', disabled: true, handler: this.onSolModPresupuesto, tooltip: '<b>Solicitar Presuuesto</b><p>Emite un correo para solicitar traspaso presupuestario</p>'});
       
        
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
		//primera carga
		this.store.baseParams.pes_estado = 'borrador';
    	this.load({params:{start:0, limit:this.tam_pag}});
		
		this.finCons = true;
		
	},
    
    
       
    onButtonNew:function(){
	       //abrir formulario de solicitud
	       var me = this;
		   me.objSolForm = Phx.CP.loadWindows('../../../sis_adquisiciones/vista/solicitud/FormSolicitud.php',
	                                'Formulario de Solicitud de Compra',
	                                {
	                                    modal:true,
	                                    width:'90%',
	                                    height:'90%'
	                                }, {data:{objPadre: me}
	                                }, 
	                                this.idContenedor,
	                                'FormSolicitud',
	                                {
	                                    config:[{
	                                              event:'successsave',
	                                              delegate: this.onSaveForm,
	                                              
	                                            }],
	                                    
	                                    scope:this
	                                 });    
	    
		
           
    },
    
    onSaveForm: function(form,  objRes){
    	var me = this;
    	
    	//muestra la ventana de documentos para este proceso wf
	    Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Chequear documento del WF',
                    {
                        width:'90%',
                        height:500
                    },
                    {
				    	id_solicitud: objRes.ROOT.datos.id_solicitud,
				    	id_proceso_wf: objRes.ROOT.datos.id_proceso_wf,
				    	num_tramite: objRes.ROOT.datos.num_tramite,
				    	estao: objRes.ROOT.datos.estado,
				    	nombreVista: 'Formulario de solicitud de compra',
				    	tipo: 'solcom'  //para crear un boton de guardar directamente en la ventana de documentos
				    	
				    },
                    this.idContenedor,
                    'DocumentoWf',
                    {
                        config:[{
                                  event:'finalizarsol',
                                  delegate: this.onCloseDocuments,
                                  
                                }],
                        
                        scope:this
                     }
        )
    	
    	form.panel.destroy()
        me.reload();
    	
    },
    
    onCloseDocuments: function(paneldoc, data, directo){
    	var newrec = this.store.getById(data.id_solicitud);
    	if(newrec){
	    	this.sm.selectRecords([newrec]);
	    	if(directo === true){
	    		 this.fin_requerimiento(paneldoc);
	    	}
	    	else{
		    	if(confirm("¿Desea mandar la solictud para aprobación?")){
		    		this.fin_requerimiento(paneldoc);
		    	}	
	    	}
	    		
    	}
    	
		    	
    },
    onButtonEdit:function(){

       this.cmpFechaSoli.disable();
       this.cmpIdDepto.disable();   
       this.Cmp.id_funcionario.disable();     
       this.Cmp.id_categoria_compra.disable();
       this.Cmp.precontrato.disable();
       this.Cmp.tipo_concepto.disable();
       this.Cmp.id_moneda.disable();


       Phx.vista.SolicitudReqMulGes.superclass.onButtonEdit.call(this);
       this.Cmp.id_funcionario.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
       //this.Cmp.fecha_soli.fireEvent('change');  

        //nos permite habilitar para la categoria de compra internacional el campo nro_po, fecha_po
       if(this.Cmp.id_categoria_compra.getValue()==4){
           this.mostrarComponente(this.Cmp.nro_po);
           this.mostrarComponente(this.Cmp.fecha_po);
       }else{
           this.ocultarComponente(this.Cmp.nro_po);
           this.ocultarComponente(this.Cmp.fecha_po);
       }


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
             
           this.Cmp.tipo_concepto.on('select',function(cmp,rec){
           	
           	   //identificamos si es un bien o un servicio
           	   if(this.isInArray(rec.json, this.arrayStore['Bien'])){
           	   	  this.Cmp.tipo.setValue('Bien');
           	   }
           	   else{
           	   	  this.Cmp.tipo.setValue('Servicio');
           	   }
           	   
           	   if(this.Cmp.tipo.getValue() == 'Bien'){
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
    
    
       fin_requerimiento:function(paneldoc)
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
                argument: { paneldoc: paneldoc},
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
              
                 if(resp.argument.paneldoc.panel){
                 	resp.argument.paneldoc.panel.destroy();
                 }
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
      Phx.vista.SolicitudReqMulGes.superclass.preparaMenu.call(this,n);  
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
        var tb = Phx.vista.SolicitudReqMulGes.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('fin_requerimiento').disable();
            this.getBoton('btnSolpre').disable(); 
            this.menuAdq.disable();
        }
        
       return tb
    },    
       
	
	south:
          { 
          url:'../../../sis_adquisiciones/vista/solicitud_det/SolicitudReqDetMulGes.php',
          title:'Detalle', 
          height:'50%',
          cls:'SolicitudReqDetMulGes'
         }
};
</script>
