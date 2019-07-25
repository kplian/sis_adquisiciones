<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CotizacionAdq = {
    require:'../../../sis_adquisiciones/vista/cotizacion/Cotizacion.php',
    requireclase:'Phx.vista.Cotizacion',
    title:'Solicitud',
    nombreVista: 'CotizacionAdq',
    
    constructor: function(config) {
        
        
         Phx.vista.CotizacionAdq.superclass.constructor.call(this,config);
          
         
        
         this.addButton('fin_registro',{text:'Finalizar Registro de Cotizacion',iconCls: 'badelante',disabled:true,handler:this.fin_registro,tooltip: '<b>Finalizar</b><p>Finalizar registro de cotización</p>'});
         
         
         this.addButton('btnAdjudicar',{
                    text :'Recomendar',
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onAdjudicarTodo,
                    tooltip : '<b>Recomedar Todo</b><br/><b>Recomienda la adjudicación de todo lo disponible</b>'
          });
          
           this.addButton('btnSolApro',{
                         text:'Sol. Apro.',
                         iconCls: 'bok',
                         disabled:true,
                         handler:this.onSolAprobacion,
                         tooltip: '<b>Solictar Aprobación</b><p>Solictar Aprobación del RPC</p>'});
           
        
       
       
        
       this.addButton('btnHabPago',{text:'Habilitar Pago',iconCls: 'bcharge',disabled:false,handler:this.sigEstado,tooltip: '<b>Pasar al Siguiente Estado</b>'});
          
       this.addButton('btnSendMail',{text:'Sol Cotizacion',iconCls: 'bemail',disabled:true,handler:this.onSendMail,tooltip: '<b>Solictar Cotizacion</b><p>Solicta la cotizacion por correo al proveedor</p>'});
       
       this.addButton('btnSolCon',{text:'Hab. Contr.',iconCls: 'bemail',disabled:true,handler:this.onSolContrato,tooltip: '<b>HAbilitar Contrato</b><p>si tiene habilitado los contratos en esta cotización, antes de armar el plan de pago pasara al área legal</p>'});
       
       
       this.addButton('btnPreing',{
                    text :'Preingreso',
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onPreing,
                    tooltip : '<b>Preingreso</b><br/><b>Generación del Preingreso</b>'
          });
          
          this.addButton('btnObs',{
                    text :'Obs Wf',
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onOpenObs,
                    tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
          });
          
          this.addButton('btnCorreoWf',{
                    text :'Correos',
                    iconCls : 'bemail',
                    disabled: true,
                    handler : this.onCorreoWf,
                    tooltip : '<b>Correos</b><br/><b>Correos enviados durante el proceso wf</b>'
          });
          
		//RCM
        //this.addButton('btnObPag',{text :'Obligación Pago',iconCls:'bdocuments',disabled: true, handler : this.onButtonObPag,tooltip : '<b>Obligación de Pago</b><br/><b>Formulario para el registro de la Obligación de Pago</b>'});
           
        
        
        this.init();
        this.iniciarEventos();
        
        //crea fomrlario para generar OC
        this.crearFormularioFechaOC();
        
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
                        url: '../../sis_adquisiciones/control/Cotizacion/listarDeptoFiltradoCotizacion',
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
        
      
        this.store.baseParams={id_proceso_compra:this.id_proceso_compra,tipo_interfaz: this.nombreVista}; 
        this.load({params:{start:0, limit:this.tam_pag}});
        
        
    },
    
    
    crearFormularioFechaOC:function(){
        
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
                        allowBlank: false,
                        readOnly: true
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
        
    },
    
    EnableSelect:function(n){
         Phx.vista.CotizacionAdq.superclass.EnableSelect.call(this,n,{desc_moneda_sol:this.desc_moneda});
    },
    
    onButtonNew:function(){         
            Phx.vista.CotizacionAdq.superclass.onButtonNew.call(this);
            
            this.cmbMoneda.disable();
            this.cmpTipoCambioConv.disable();
            this.getComponente('id_proceso_compra').setValue(this.id_proceso_compra); 
            
            this.ocultarComponente(this.Cmp.correo_contacto);
            this.ocultarComponente(this.Cmp.telefono_contacto);
            this.ocultarComponente(this.Cmp.funcionario_contacto);
            this.ocultarComponente(this.Cmp.lugar_entrega); 
            this.ocultarComponente(this.Cmp.tiempo_entrega); 
            this.mostrarComponente(this.Cmp.prellenar_oferta); 

        
    },
    
    onButtonEdit:function(){ 
    	
    	        
            Phx.vista.CotizacionAdq.superclass.onButtonEdit.call(this);
            this.mostrarComponente(this.Cmp.correo_contacto);
            this.mostrarComponente(this.Cmp.telefono_contacto);
            this.mostrarComponente(this.Cmp.funcionario_contacto);
            this.mostrarComponente(this.Cmp.lugar_entrega); 
            this.mostrarComponente(this.Cmp.fecha_entrega); 
            this.mostrarComponente(this.Cmp.tiempo_entrega); 
            this.ocultarComponente(this.Cmp.prellenar_oferta); 
            
            
     
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
        
        
        onSolAprobacion:function(){
            
            this.cmpFechaOC.setValue(new Date());
            //comentado temporalmente para regularizar
            //this.cmpFechaOC.setReadOnly(true);
            this.wOC.show(); 
            
        },
        
        
        onSubmitGenOC:function()
        {                   
            var d= this.sm.getSelected().data;
           
            this.DataSelected = d
            
            Phx.CP.loadingShow();
            
            Ext.Ajax.request({
                url:'../../sis_adquisiciones/control/Cotizacion/siguienteEstadoCotizacion',
                params:{id_cotizacion:d.id_cotizacion,
                        fecha_oc: this.cmpFechaOC.getValue().dateFormat('d/m/Y'),
                        operacion:'verificar'},
                
                //params:{id_cotizacion:d.id_cotizacion,operacion:'sol_apro'},
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
                
                        if (reg.ROOT.datos.operacion=='preguntar_todo'){
                            
                            if(reg.ROOT.datos.num_estados==1 && (reg.ROOT.datos.num_funcionarios==1 || reg.ROOT.datos.num_funcionarios==0)){
                               //directamente mandamos los datos
                               Phx.CP.loadingShow();
                               var d= this.sm.getSelected().data;
                               Ext.Ajax.request({
                                // form:this.form.getForm().getEl(),
                                url:'../../sis_adquisiciones/control/Cotizacion/siguienteEstadoCotizacion',
                                params:{id_cotizacion:d.id_cotizacion,
                                    operacion:'cambiar',
                                    fecha_oc: this.cmpFechaOC.getValue().dateFormat('d/m/Y'),
                                    id_tipo_estado:reg.ROOT.datos.id_tipo_estado,
                                    id_funcionario:reg.ROOT.datos.id_funcionario_estado,
                                    id_depto:reg.ROOT.datos.id_depto_estado,
                                    id_solicitud:d.id_solicitud,
                                    obs:'Se solicita  la revision de la Cotización de la solictud de compra '+ this.DataSelected.numero
                                    },
                                success:this.successSinc,
                                failure: this.conexionFailure,
                                timeout:this.timeout,
                                scope:this
                               }); 
                           }
                           else{
                                 
                               alert('Estado siguiente esta mal parametrizado, solo se admite un funcionario, un estado, sin instrucciones adicionales')
                           }
                     }
                
                    this.wDEPTO.hide();
                    this.wOC.hide(),
                    this.reload();
                 }
                 else{
                    alert('ocurrio un error durante el proceso')
                }
        },
        
       

        
                                

        onHabPag:function(){
           
            var data = this.getSelectedData();
            this.cmpDeptoTes.reset();
            this.cmpDeptoTes.store.baseParams.id_cotizacion = data.id_cotizacion;
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
        
        onPreing:function(){
            var rec = this.sm.getSelected();
            if(rec.data){
            	Ext.Msg.confirm('Confirmación',
				'¿Está seguro de generar el Preingreso?', 
				function(btn) {
					if (btn == "yes") {
						Phx.CP.loadingShow();
			            Ext.Ajax.request({
			                url:'../../sis_adquisiciones/control/Cotizacion/generarPreingreso',
			                params:{id_cotizacion:rec.data.id_cotizacion},
			                success:this.successSinc,
			                failure: this.conexionFailure,
			                timeout:this.timeout,
			                scope:this
			            });
					}
				},this);
  
            } else{
            	Ext.Msg.alert('Mensaje','Seleccione un registro y vuelva a intentarlo');
            }
        },
        
       preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.CotizacionAdq.superclass.preparaMenu.call(this,n);
          this.menuAdq.enable();
          this.getBoton('btnReporte').enable();

          //this.getBoton('btnReporte').enable(); 
         
              
              if(data['estado'] == 'borrador'){
                 this.getBoton('fin_registro').enable();
                 this.getBoton('btnAdjudicar').disable();
                 this.getBoton('btnSolCon').disable();
                 
                 this.getBoton('btnSolApro').disable();
                 this.getBoton('ant_estado').disable();
                 this.getBoton('btnRepOC').disable();
                 
                 if(data.email != '' &&data.email != undefined){ 
                   this.getBoton('btnSendMail').enable(); 
                 }
               }
              else{
                   this.getBoton('ant_estado').enable();
                   this.getBoton('btnSendMail').disable(); 
                   
                   if(data['estado']=='cotizado'){
                     this.getBoton('btnAdjudicar').enable();
                     this.getBoton('btnSolApro').enable();
                     this.getBoton('btnRepOC').disable();   
                   }
                   else{
                      this.getBoton('btnAdjudicar').disable();
                      this.getBoton('btnSolCon').disable(); 
                      this.getBoton('btnSolApro').disable();
                     
                   }
                   
                   if(data['estado']=='adjudicado'|| data['estado']=='contrato_pendiente'|| data['estado']=='contrato_elaborado' || data['estado']=='pago_habilitado'|| data['estado']=='finalizada'){
                       
                    if(data['requiere_contrato']=='no'){
                     	 this.getBoton('btnRepOC').enable();
                     }
                    this.getBoton('btnSolCon').enable();
                    
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
               
               if (data['estado']==  'anulado' || data['estado']=='finalizada'){
                   this.getBoton('ant_estado').disable();
                   this.getBoton('fin_registro').disable();
               }
               
               if (data['estado']!='adjudicado'&&data['estado']!='contrato_elaborado'){
                   this.getBoton('btnHabPago').disable();
               }
               else{
                    if(data['estado']=='adjudicado'&&data['requiere_contrato']=='si'){
                    	this.getBoton('btnHabPago').setIconClass('bdocuments');
                    	this.getBoton('btnHabPago').setText( 'Solicitar Contrato' ); 
                    	this.getBoton('btnHabPago').setTooltip('Solicita el contrato al área legal')
                    }
                    else{
                    	this.getBoton('btnHabPago').setIconClass('bcharge');
                    	this.getBoton('btnHabPago').setText( 'Habilitar Pago' );
                    	this.getBoton('btnHabPago').setTooltip('Habilita la opción de registrar la obligación de pago' )
                    }
                    
                    this.getBoton('btnHabPago').enable();  
               }
                 
              if (data['estado']=='pago_habilitado' ){
                   this.getBoton('ant_estado').disable();
                   this.getBoton('btnPreing').enable();
                   this.getBoton('btnSolCon').disable();
                  
              } 
              
              if(data['estado']=='contrato_pendiente' || data['estado']=='contrato_elaborado'){
              	 this.getBoton('ant_estado').disable();
              	  this.getBoton('btnSolCon').disable();
              }
               
              if (data['estado']=='recomendado'){
                   this.getBoton('btnRepOC').disable();
                   this.getBoton('btnSolCon').disable();
              }
              if (data['estado']=='cotizado'){
                  this.getBoton('btnSolCon').enable();
              }
               
               
            this.getBoton('btnObs').enable();    
            this.getBoton('btnChequeoDocumentosWf').enable(); 
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btnCorreoWf').enable();
              
            return tb 
     }, 
     
    
     
     liberaMenu:function(){
        var tb = Phx.vista.CotizacionAdq.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('fin_registro').disable();
            this.getBoton('btnAdjudicar').disable();
            this.getBoton('btnSolCon').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnReporte').disable();
            this.getBoton('btnSendMail').disable(); 
            this.getBoton('btnPreing').disable();
            this.getBoton('btnRepOC').disable();
            this.getBoton('btnObs').disable();  
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnChequeoDocumentosWf').disable();
            this.getBoton('btnCorreoWf').disable();
            
            this.menuAdq.disable();
            
            
         }
       
      
       return tb
    },
    
    
    
    
    onSendMail:function(){
        
       Phx.CP.loadingShow();
        
        var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_adquisiciones/control/Cotizacion/sendMailCotizacion',
            params:{id_cotizacion:rec.data.id_cotizacion,
                    id_proceso_compra:rec.data.id_proceso_compra,
                    total:'unitario',
                    tipo:rec.data.estado,
                    email:rec.data.email},
            success: this.successMail,
            failure: this.conexionFailure,
            scope:this
        }); 
        
        
    },
    
      successMail:function(resp){
            Phx.CP.loadingHide();
           
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                alert('Correo enviado con exito')
             }else{
                alert('ocurrio un error durante el proceso')
            }
        } ,
    //WIZARD
    sigEstado:function(){                   
            var rec=this.sm.getSelected();
            if (rec.data.estado == 'adjudicado' && rec.data.requiere_contrato == 'si') {
            	this.forzar_documentos = 'si';
            	this.gruposBarraTareas = [{name:"legales",title:"Doc. Legales",grupo:0,height:0},
                            {name:"proceso",title:"Doc del Proceso",grupo:1,height:0}];
            } else {
            	this.forzar_documentos = 'no';
            	this.gruposBarraTareas = [{name:"proceso",title:"Doc del Proceso",grupo:0,height:0},
                            {name:"legales",title:"Doc. Legales",grupo:1,height:0}];
            }
            
            Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:700,
                height:450
            }, {data:{
                   id_estado_wf: rec.data.id_estado_wf,
                   id_proceso_wf: rec.data.id_proceso_wf,
                   fecha_ini: rec.data.fecha_tentativa,
                   forzar_documentos : this.forzar_documentos,
                   gruposBarraTareas: this.gruposBarraTareas,
                   check_fisico : 'si'
               }}, this.idContenedor,'FormEstadoWf',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onSaveWizard,
                          
                        }],
                
                scope:this
             })
               
     },
     
    
     onSaveWizard:function(wizard,resp){
        Phx.CP.loadingShow();
         
        Ext.Ajax.request({
            url:'../../sis_adquisiciones/control/Cotizacion/habilitarPago',
            params:{
                id_proceso_wf_act:  resp.id_proceso_wf_act,
                id_estado_wf_act:   resp.id_estado_wf_act,
                id_tipo_estado:     resp.id_tipo_estado,
                id_funcionario_wf:  resp.id_funcionario_wf,
                id_depto_wf:        resp.id_depto_wf,
                obs:                resp.obs,
                json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
            success:this.successWizard,
            failure: this.conexionFailure,
            argument:{wizard:wizard},
            timeout:this.timeout,
            scope:this
        });
    },
     
    successWizard:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
     },
     
     onOpenObs:function() {
            var rec=this.sm.getSelected();
            
            var data = {
            	id_proceso_wf: rec.data.id_proceso_wf,
            	id_estado_wf: rec.data.id_estado_wf,
            	num_tramite: rec.data.num_tramite
            }
            
            console.log(rec.data)
            Phx.CP.loadWindows('../../../sis_workflow/vista/obs/Obs.php',
                    'Observaciones del WF',
                    {
                        width:'80%',
                        height:'70%'
                    },
                    data,
                    this.idContenedor,
                    'Obs'
        )
    },
    
    onCorreoWf: function() {
            var rec=this.sm.getSelected();
            
            var data = {
            	id_proceso_wf: rec.data.id_proceso_wf,
            	id_estado_wf: rec.data.id_estado_wf,
            	num_tramite: rec.data.num_tramite
            }
            
            console.log(rec.data)
            Phx.CP.loadWindows('../../../sis_parametros/vista/alarma/CorreoWf.php',
                    'Correos enviados',
                    {
                        width:'80%',
                        height:'70%'
                    },
                    data,
                    this.idContenedor,
                    'CorreoWf'
        )
    }
    
};
</script>
