<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*dar el visto a solicitudes de compra
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudVb = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_adquisiciones/vista/solicitud/Solicitud.php',
	requireclase:'Phx.vista.Solicitud',
	title:'Solicitud',
	nombreVista: 'solicitudVb',
	
	constructor: function(config) {
	    
	    this.maestro=config.maestro;
	    
	    this.Atributos[this.getIndAtributo('id_funcionario')].form=false;
        this.Atributos[this.getIndAtributo('id_funcionario_aprobador')].form=false;
        this.Atributos[this.getIndAtributo('id_moneda')].form=false;
        //this.Atributos[this.getIndAtributo('id_proceso_macro')].form=false;
        this.Atributos[this.getIndAtributo('fecha_soli')].form=false;
        this.Atributos[this.getIndAtributo('id_categoria_compra')].form=false;
        this.Atributos[this.getIndAtributo('id_uo')].form=false;
        this.Atributos[this.getIndAtributo('id_depto')].form=false;
        this.Atributos[this.getIndAtributo('revisado_asistente')].grid=true; 
        
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
        
    	Phx.vista.SolicitudVb.superclass.constructor.call(this,config);
    	this.addButton('ini_estado',{  argument: {estado: 'inicio'},text:'Dev. al Solicitante',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Retorna la Solcitud al estado borrador</b>'});
        this.addButton('ant_estado',{argument: {estado: 'anterior'},text:'Rechazar',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        this.addButton('sig_estado',{text:'Aprobar',iconCls: 'badelante',disabled:true,handler:this.sigEstado,tooltip: '<b>Pasar al Siguiente Estado</b>'});
        
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
                    xtype: 'combo',
                    name: 'instruc_rpc',
                    fieldLabel:'Intrucciones',
                    allowBlank: false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'local',
                    valueField: 'estilo',
                    gwidth: 100,
                    value: 'Orden de Bien/Servicio',
                    //store:['Iniciar Contrato','Orden de Bien/Servicio','Cotizar','Solicitar Pago']
                    store: ['Iniciar Contrato','Orden de Bien/Servicio','Cotizar']
                },
                {
                    name: 'obs',
                    xtype: 'textarea',
                    fieldLabel: 'Obs',
                    allowBlank: true,
                    value:'',
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
        
        
        this.store.baseParams={tipo_interfaz:this.nombreVista};
        //coloca filtros para acceso directo si existen
        if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
        //carga inicial de la pagina
        this.load({params:{start:0, limit:this.tam_pag}}); 
        
        this.cmbTipoEstado =this.formEstado.getForm().findField('id_tipo_estado');
        this.cmbTipoEstado.store.on('loadexception', this.conexionFailure,this);
     
        this.cmbFuncionarioWf =this.formEstado.getForm().findField('id_funcionario_wf');
        this.cmbFuncionarioWf.store.on('loadexception', this.conexionFailure,this);
      
        this.cmpObs=this.formEstado.getForm().findField('obs');
        
        this.cmbIntrucRPC =this.formEstado.getForm().findField('instruc_rpc');
       
        
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
        
        
		
	},
	confSigEstado :function() {                   
            var d= this.sm.getSelected().data;
            
           
           
            if ( this.formEstado.getForm().isValid()){
                 Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        // form:this.form.getForm().getEl(),
                        url:'../../sis_adquisiciones/control/Solicitud/siguienteEstadoSolicitud',
                        params:{
                            id_solicitud:d.id_solicitud,
                            id_estado_wf:d.id_estado_wf,
                            operacion:'cambiar',
                            id_tipo_estado:this.cmbTipoEstado.getValue(),
                            id_funcionario:this.cmbFuncionarioWf.getValue(),
                            obs:this.cmpObs.getValue(),
                            instruc_rpc:this.cmbIntrucRPC.getValue()
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
             this.formEstado.getForm().reset();
            this.cmbTipoEstado.reset();
            this.cmbFuncionarioWf.reset();
            this.cmbFuncionarioWf.store.baseParams.id_estado_wf=d.id_estado_wf;
            this.cmbFuncionarioWf.store.baseParams.fecha=d.fecha_soli;
            
            this.cmbTipoEstado.show();
            this.cmbFuncionarioWf.show();
            this.cmbTipoEstado.enable();
         
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Solicitud/siguienteEstadoSolicitud',
                params:{id_solicitud:d.id_solicitud,
                        id_estado_wf:d.id_estado_wf, 
                        operacion:'verificar',
                        obs:this.cmpObs.getValue()},
                success:this.successSinc,
                argument:{data:d},
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
        },
       
      antEstado:function(res,eve) {                   
            this.wEstado.buttons[0].hide();
            this.wEstado.buttons[1].show();
            this.wEstado.show();
            
            this.cmbTipoEstado.hide();
            this.cmbFuncionarioWf.hide();
            this.cmbTipoEstado.disable();
            this.cmbFuncionarioWf.disable();
            this.cmbIntrucRPC.hide();
            this.cmbIntrucRPC.disable(); 
            this.cmpObs.setValue('');
            
            this.sw_estado =res.argument.estado;
           
               
        },
        
        antEstadoSubmmit:function(res){
            var d= this.sm.getSelected().data;
           
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            operacion=  this.sw_estado == 'inicio'?'inicio':operacion; 
            
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Solicitud/anteriorEstadoSolicitud',
                params:{id_solicitud:d.id_solicitud, 
                        id_estado_wf:d.id_estado_wf, 
                        operacion: operacion,
                        obs:this.cmpObs.getValue()},
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
                   if(reg.ROOT.datos.num_estados==1 && reg.ROOT.datos.num_funcionarios==1){
                       //directamente mandamos los datos
                       Phx.CP.loadingShow();
                       var d= this.sm.getSelected().data;
                       Ext.Ajax.request({
                        // form:this.form.getForm().getEl(),
                        url:'../../sis_adquisiciones/control/Solicitud/siguienteEstadoSolicitud',
                        params:{id_solicitud:d.id_solicitud,
                            operacion:'cambiar',
                            id_tipo_estado:reg.ROOT.datos.id_tipo_estado,
                            id_funcionario:reg.ROOT.datos.id_funcionario_estado,
                            id_depto:reg.ROOT.datos.id_depto_estado,
                            id_solicitud:d.id_solicitud,
                            id_estado_wf:d.id_estado_wf,
                            obs:this.cmpObs.getValue(),
                            instruc_rpc:this.cmbIntrucRPC.getValue()
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
                     if(resp.argument.data.estado=='vbrpc'){
                        this.cmbIntrucRPC.show();
                        this.cmbIntrucRPC.enable();
                        this.cmbIntrucRPC.setValue('Orden de Bien/Servicio')
                     }
                     else{
                         this.cmbIntrucRPC.hide();
                         this.cmbIntrucRPC.disable(); 
                         
                     }
                     
                     this.cmpObs.setValue('');
                     this.cmbFuncionarioWf.disable();
                     this.wEstado.buttons[1].hide();
                     this.wEstado.buttons[0].show();
                     this.wEstado.show();  
                     
                     
                     //precarga como de estado
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
                
                  this.reload();
                  this.wEstado.hide();
                
                }
               
                
            }else{
                
                alert('ocurrio un error durante el proceso')
            }
           
            
        },
     
  //deshabilitas botones para informacion historica
  desBotoneshistorico:function(){
      
      this.getBoton('ant_estado').disable();
      this.getBoton('sig_estado').disable();
      this.getBoton('ini_estado').disable();
      
  },
  preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.SolicitudVb.superclass.preparaMenu.call(this,n);  
      
      if(this.historico == 'no'){
          if(data.estado =='aprobado' ){ 
            this.getBoton('ant_estado').enable();
            this.getBoton('sig_estado').disable();
            this.getBoton('ini_estado').enable();
            }
            if(data.estado =='proceso'){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').disable();
                this.getBoton('ini_estado').disable();
            }
            
            if(data.estado =='anulado' || data.estado =='finalizado'){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').disable();
                this.getBoton('ini_estado').disable();
            }
            
            if(data.estado !='aprobado' && data.estado !='proceso' &&data.estado !='anulado' && data.estado !='finalizado' ){
                this.getBoton('ant_estado').enable();
                this.getBoton('sig_estado').enable();
                this.getBoton('ini_estado').enable();
            }
            /*if(data.estado !='aprobado' && data.estado !='proceso' ){
                this.getBoton('ant_estado').disable();
                this.getBoton('sig_estado').disable();
                this.getBoton('ini_estado').disable();
            }*/
            
           //habilitar reporte de colicitud de comrpa y preorden de compra
           this.menuAdq.enable();
      } 
      else{
          this.desBotoneshistorico();
          
      }   
      return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.SolicitudVb.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ini_estado').disable();
            this.getBoton('ant_estado').disable();
            //boton de reporte de solicitud y preorden de compra
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
