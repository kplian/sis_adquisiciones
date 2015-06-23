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
Phx.vista.CotizacionVbDin = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
    require:'../../../sis_adquisiciones/vista/cotizacion/Cotizacion.php',
    requireclase:'Phx.vista.Cotizacion',
    title:'Cotizacion VB',
    nombreVista: 'CotizacionVbDin',
    
    constructor: function(config) {
        this.maestro=config.maestro;
        
        //funcionalidad para listado de historicos
        this.historico = 'no';
        this.tbarItems = ['-',{
            text: 'Histórico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.historico = 'si';
                     this.desBotoneshistorico();
                }
                else{
                   this.historico = 'no' 
                }
                
                this.store.baseParams.historico = this.historico;
                this.reload();
             },
            scope: this
           }];
        
        
        Phx.vista.CotizacionVbDin.superclass.constructor.call(this,config);
        
        this.addButton('sig_estado',{
                text:'Siguiente',
                iconCls: 'badelante',
                disabled:true,
                handler:this.sigEstado,
                tooltip: '<b>Pasar al Siguiente Estado</b>'});
        
        
         this.addButton('btnGenOC',{
                    text :'Aprobar',
                    iconCls : 'bok',
                    disabled: true,
                    handler : this.AprobarSolicitud,
                    tooltip : '<b>Aprobar Adjudicación</b><br/><b> La recomendación queda aprobada </b>'
          });
         
        this.addButton('btnSolCom',{
            text :'Sol Comp.',
            iconCls : 'bpdf32',
            disabled: true,
            handler : this.onButtonSolicitud,
            tooltip : '<b>Reporte Solicitud de Compra</b><br/><b>Reporte solicitud de compra</b>'
        });
        
        this.addButton('btnCuadroComparativo',{
											 text :'Cuadro Comparativo',
											 iconCls : 'bexcel',
											 disabled: true,
											 handler : this.onCuadroComparativo,
											 tooltip : '<b>Cuadro Comparativo</b><br/><b>Cuadro comparativo de cotizaciones</b>'
	 						});         
          
        
        this.addButton('btnSolCon',{text:'Hab. Contr.',iconCls: 'bemail',disabled:true,handler:this.onSolContrato,tooltip: '<b>HAbilitar Contrato</b><p>si tiene habilitado los contratos en esta cotización, antes de armar el plan de pago pasara al área legal</p>'});
       
       
        this.store.baseParams={tipo_interfaz:this.nombreVista}; 
        //coloca filtros para acceso directo si existen
        if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
        this.load({params:{start:0, limit:this.tam_pag}});
        
        this.init();
        
        //formulario de paso de estados
        
        
        //formulario para preguntar sobre siguiente estado
        //agrega ventana para selecion de RPC
            
                
        this.formEstado = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
           
            border: false,
            layout: 'form',
             autoHeight: true,
           
    
            items: [
                {
                    xtype: 'combo',
                    name: 'id_tipo_estado',
                    hiddenName: 'id_tipo_estado',
                    fieldLabel: 'Siguiente Estado',
                    listWidth:280,
                    allowBlank: false,
                    emptyText:'Elija el estado siguiente',
                    store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_workflow/control/TipoEstado/listarTipoEstado',
                        id: 'id_tipo_estado',
                        root:'datos',
                        sortInfo:{
                            field:'tipes.codigo',
                            direction:'ASC'
                        },
                        totalProperty:'total',
                        fields: ['id_tipo_estado','codigo_estado','nombre_estado'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'tipes.nombre_estado#tipes.codigo'}
                    }),
                    valueField: 'id_tipo_estado',
                    displayField: 'codigo_estado',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    width:210,
                    gwidth:220,
                    minChars:2,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo_estado}</p>Prioridad: <strong>{nombre_estado}</strong> </div></tpl>'
                
                },
                {
                    xtype: 'combo',
                    name: 'id_funcionario_wf',
                    hiddenName: 'id_funcionario_wf',
                    fieldLabel: 'Funcionario Resp.',
                    allowBlank: false,
                    emptyText:'Elija un funcionario',
                    listWidth:280,
                    store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_workflow/control/TipoEstado/listarFuncionarioWf',
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
                        baseParams:{par_filtro:'fun.desc_funcionario1'}
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
                    minChars:2,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_funcionario}</p>Prioridad: <strong>{prioridad}</strong> </div></tpl>'
                
                },
                    {
                        name: 'obs',
                        xtype: 'textarea',
                        fieldLabel: 'Intrucciones',
                        allowBlank: false,
                        anchor: '80%',
                        maxLength:500
                    }]
        });
        
        
        this.wEstado = new Ext.Window({
            title: 'Estados',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 380,
            height: 290,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formEstado,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.confSigEstado,
                scope:this
                
            },
             {
                    text: 'Guardar',
                    handler:this.antEstadoSubmmit,
                    scope:this
                    
             },
             {
                text: 'Cancelar',
                handler:function(){this.wEstado.hide()},
                scope:this
            }]
        });
        
        
        
        
        
        
        this.cmbTipoEstado =this.formEstado.getForm().findField('id_tipo_estado');
        this.cmbTipoEstado.store.on('loadexception', this.conexionFailure,this);
     
        this.cmbFuncionarioWf =this.formEstado.getForm().findField('id_funcionario_wf');
        this.cmbFuncionarioWf.store.on('loadexception', this.conexionFailure,this);
      
        this.cmpObs=this.formEstado.getForm().findField('obs');
        
        
        
        this.cmbTipoEstado.on('select',function(){
            
            this.cmbFuncionarioWf.enable();
            this.cmbFuncionarioWf.store.baseParams.id_tipo_estado = this.cmbTipoEstado.getValue();
            this.cmbFuncionarioWf.modificado=true;
            
            this.cmbFuncionarioWf.store.load({params:{start:0,limit:this.tam_pag}, 
                       callback : function (r) {
                           if (r.length >= 1 ) {                       
                                this.cmbFuncionarioWf.setValue(r[0].data.id_funcionario);
                                this.cmbFuncionarioWf.fireEvent('select', r[0]);
                            }    
                                            
                        }, scope : this
                    });
            
            
            
        },this);
        
        
    } ,
    ActList:'../../sis_adquisiciones/control/Cotizacion/listarCotizacionRPC',
  
  
  
  
  AprobarSolicitud:function(){
    
            var d = this.sm.getSelected().data;
           
            this.DataSelected = d
            
            Phx.CP.loadingShow();
            
            Ext.Ajax.request({
                url:'../../sis_adquisiciones/control/Cotizacion/generarOC',
                params:{id_cotizacion:d.id_cotizacion,
                        operacion:'verificar'},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });  
      
  },
  
  onButtonSolicitud:function(){
        var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_adquisiciones/control/Solicitud/reporteSolicitud',
            params:{'id_solicitud':rec.data.id_solicitud,'estado':'en_proceso'},
            success: this.successExport,
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
                   if(reg.ROOT.datos.num_estados==1 && reg.ROOT.datos.num_funcionarios==1){
                       //directamente mandamos los datos
                       Phx.CP.loadingShow();
                       var d= this.sm.getSelected().data;
                       Ext.Ajax.request({
                        // form:this.form.getForm().getEl(),
                         url:'../../sis_adquisiciones/control/Cotizacion/siguienteEstadoCotizacion',
                        params:{id_cotizacion:d.id_cotizacion,
                            operacion:'cambiar',
                            id_tipo_estado:reg.ROOT.datos.id_tipo_estado,
                            id_funcionario:reg.ROOT.datos.id_funcionario_estado,
                            id_depto:reg.ROOT.datos.id_depto_estado,
                            id_solicitud:d.id_solicitud,
                            obs:this.cmpObs.getValue()
                            },
                        success:this.successSinc,
                        failure: this.conexionFailure,
                        timeout:this.timeout,
                        scope:this
                    }); 
                 }
                   else{
                     this.cmbTipoEstado.store.baseParams.estados= reg.ROOT.datos.estados;
                     this.cmbTipoEstado.modificado=true;
                     this.cmpObs.setValue('');
                     this.cmbFuncionarioWf.disable();
                     this.wEstado.buttons[1].hide();
                     this.wEstado.buttons[0].show();
                     this.wEstado.show();
                     
                     //TODO  
                     
                    this.cmbTipoEstado.store.load({params:{start:0,limit:this.tam_pag}, 
                       callback : function (r) {
                            if (r.length == 1 ) {                       
                                this.cmbTipoEstado.setValue(r[0].data.id_tipo_estado);
                                this.cmbTipoEstado.fireEvent('select', r[0]);
                            }    
                                            
                        }, scope : this
                    });
                     
                     
                       
                  }
                   
               }
               
                if (reg.ROOT.datos.operacion=='cambio_exitoso'){
                
                 
                  this.wEstado.hide();
                
                }
                this.reload();
                
            }else{
                
                alert('ocurrio un error durante el proceso')
            }
           
            
        },
        
        
       
    	
    	onCuadroComparativo: function(){
			var rec=this.sm.getSelected();
		    Ext.Ajax.request({
		             url:'../../sis_adquisiciones/control/ProcesoCompra/cuadroComparativo',
		             params:{'id_proceso_compra':rec.data.id_proceso_compra},
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
       
       confSigEstado :function() {                   
            var d= this.sm.getSelected().data;
           
            if ( this.formEstado .getForm().isValid()){
                 Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        // form:this.form.getForm().getEl(),
                         url:'../../sis_adquisiciones/control/Cotizacion/siguienteEstadoCotizacion',
                        params:{
                            id_cotizacion:d.id_cotizacion,
                            operacion:'cambiar',
                            id_tipo_estado:this.cmbTipoEstado.getValue(),
                            id_funcionario:this.cmbFuncionarioWf.getValue(),
                            obs:this.cmpObs.getValue()
                            },
                        success:this.successSinc,
                        failure: this.conexionFailure,
                        timeout:this.timeout,
                        scope:this
                    }); 
              }    
        },   
    
      sigEstado:function(){                   
            var d= this.sm.getSelected().data;
           
            Phx.CP.loadingShow();
            this.cmbTipoEstado.reset();
            this.cmbFuncionarioWf.reset();
            this.cmbFuncionarioWf.store.baseParams.id_estado_wf=d.id_estado_wf;
            this.cmbFuncionarioWf.store.baseParams.fecha=d.fecha_coti;
            
            this.cmbTipoEstado.show();
            this.cmbFuncionarioWf.show();
            this.cmbTipoEstado.enable();
         
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Cotizacion/siguienteEstadoCotizacion',
                params:{id_cotizacion:d.id_cotizacion,
                        operacion:'verificar',
                        obs:this.cmpObs.getValue()},
                success:this.successSinc,
                argument:{data:d},
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
        },

      //deshabilitas botones para informacion historica
      desBotoneshistorico:function(){
          
          this.getBoton('sig_estado').disable();
          this.getBoton('ant_estado').disable();
          this.getBoton('btnGenOC').disable();
          this.getBoton('btnCuadroComparativo').enable(); 
         
          this.getBoton('btnReporte').enable(); 
          this.getBoton('btnRepOC').enable();
          this.getBoton('diagrama_gantt').enable();
         
          
      }, 
           
       preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.CotizacionVbDin.superclass.preparaMenu.call(this,n);
          this.menuAdq.enable();
          if(this.historico == 'no'){ 
                //cuadno es recomendado se habilita la aprobacion (btnGenOC) 
                //de deshabilita elpaso al siguiente estado
                //se habilita el paso al anterior estado
                
                if(data['estado']==  'recomendado'){
                     this.getBoton('btnGenOC').enable();
                     this.getBoton('sig_estado').disable(); 
                     this.getBoton('ant_estado').enable();
                     this.getBoton('btnSolCon').enable();
                }
                else{
                      this.getBoton('btnGenOC').disable();
                }
                  
                if(data['estado']=='adjudicado'){
                     this.getBoton('btnGenOC').disable();
                     this.getBoton('sig_estado').disable();
                     this.getBoton('ant_estado').enable();
                     this.getBoton('btnSolCon').disable();
                 }
               
               //el paso a siguiente solo se habilita para otros estados deiferentes de adjudicado y recomendado
               //y finalidaso
               if(data['estado']!='adjudicado' && data['estado']!= 'recomendado'&& data['estado']!= 'finalizada'){
                    this.getBoton('sig_estado').enable();
                    this.getBoton('ant_estado').enable();
               }
                //cuando esta finalizada nose peude mover mas   
               if(data['estado']=='finalizada'){
                   this.getBoton('sig_estado').disable();
                   this.getBoton('ant_estado').disable();
                   this.getBoton('btnGenOC').disable();
               }   
               //reportes
               this.getBoton('btnSolCom').enable();  
               this.getBoton('btnRepOC').enable(); 
               this.getBoton('diagrama_gantt').enable();
               this.getBoton('btnChequeoDocumentosWf').enable();
               this.getBoton('btnCuadroComparativo').enable(); 
          
          } 
          else{
              this.desBotoneshistorico();
              
          } 
         
         
     },
          
            
  liberaMenu:function(){
        var tb = Phx.vista.CotizacionVbDin.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('btnGenOC').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnRepOC').disable(); 
            this.getBoton('btnSolCom').disable();  
            
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('btnChequeoDocumentosWf').disable(); 
            this.getBoton('btnSolCon').disable();
            this.menuAdq.disable();
            
            
            }
       return tb
  },
    sortInfo:{
        field: 'cot.fecha_reg',
        direction: 'DESC'
    }
  
};
</script>
