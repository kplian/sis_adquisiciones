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
Phx.vista.SolicitudVbWzd = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require: '../../../sis_adquisiciones/vista/solicitud/Solicitud.php',
	requireclase:'Phx.vista.Solicitud',
	title:'Solicitud',
	nombreVista: 'SolicitudVbWzd',
	
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
        
    	Phx.vista.SolicitudVbWzd.superclass.constructor.call(this,config);
    	this.addButton('ini_estado',{  argument: {estado: 'inicio'},text:'Dev. al Solicitante',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Retorna la Solcitud al estado borrador</b>'});
        this.addButton('ant_estado',{argument: {estado: 'anterior'},text:'Rechazar',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        this.addButton('sig_estado',{text:'Aprobar',iconCls: 'badelante',disabled:true,handler:this.sigEstado,tooltip: '<b>Pasar al Siguiente Estado</b>'});
        
                
        this.store.baseParams={tipo_interfaz:this.nombreVista};
        //coloca filtros para acceso directo si existen
        if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
        //carga inicial de la pagina
        this.load({params:{start:0, limit:this.tam_pag}}); 
        
        
        
		
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
      Phx.vista.SolicitudVbWzd.superclass.preparaMenu.call(this,n);  
      
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
            
            
           //habilitar reporte de colicitud de comrpa y preorden de compra
           this.menuAdq.enable();
      } 
      else{
          this.desBotoneshistorico();
          
      }   
      return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.SolicitudVbWzd.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('sig_estado').disable();
            this.getBoton('ini_estado').disable();
            this.getBoton('ant_estado').disable();
            //boton de reporte de solicitud y preorden de compra
            this.menuAdq.disable();
           
        }
        return tb
    },  
    
    checkPresupuesto:function(){
    	var d = this.getSelectedData();
	    Phx.CP.loadingShow();
        Ext.Ajax.request({
            // form:this.form.getForm().getEl(),
            url:'../../sis_adquisiciones/control/Solicitud/checkPresupuesto',
            params:{id_solicitud:d.id_solicitud, id_funcionario:d.id_funcionario},
            success:this.successCheck,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        }); 
    	
    },  
    
    successCheck:function(resp){
            
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
            	this.reload();
            }
    },
    
    sigEstado:function(){                   
      	var rec=this.sm.getSelected();
      	
      	this.mostrarWizard(rec);
      	
               
     },
    mostrarWizard : function(rec) {
     	var configExtra = [];
     	this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal:true,
                                    width:700,
                                    height:450
                                }, {
                                	configExtra: configExtra,
                                	data:{
                                       id_estado_wf:rec.data.id_estado_wf,
                                       id_proceso_wf:rec.data.id_proceso_wf,
                                       fecha_ini:rec.data.fecha_tentativa,
                                       url_verificacion:'../../sis_adquisiciones/control/Solicitud/verficarSigEstSolWf'
                                    }
                                }, this.idContenedor,'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard,
                                              
                                            },
					                        {
					                          event:'requirefields',
					                          delegate: function () {
						                          	this.onButtonEdit();
										        	this.window.setTitle('Registre los campos antes de pasar al siguiente estado');
										        	this.formulario_wizard = 'si';
					                          }
					                          
					                        }],
                                    
                                    scope:this
                                 });        
     },
    onSaveWizard:function(wizard,resp){
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url:'../../sis_adquisiciones/control/Solicitud/siguienteEstadoSolicitudWzd',
            params:{
                    
                id_proceso_wf_act:  resp.id_proceso_wf_act,
                id_estado_wf_act:   resp.id_estado_wf_act,
                id_tipo_estado:     resp.id_tipo_estado,
                id_funcionario_wf:  resp.id_funcionario_wf,
                id_depto_wf:        resp.id_depto_wf,
                obs:                resp.obs,
                instruc_rpc:		'',
                json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
            success: this.successWizard,
            failure: this.failureCheck, //chequea si esta en verificacion presupeusto para enviar correo de transferencia
            argument: { wizard:wizard },
            timeout: this.timeout,
            scope: this
        });
    },
    successWizard:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    
    failureCheck:function(resp1,resp2,resp3){
       	  
       	   this.conexionFailure(resp1,resp2,resp3);
       	   var d= this.sm.getSelected().data;
       	   if(d.estado == 'vbpresupuestos'){
       	   	 this.checkPresupuesto();
       	   }
       	  
       },
       
    //para retroceder de estado
    antEstado:function(res){
         var rec=this.sm.getSelected();
         Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
            'Estado de Wf',
            {
                modal:true,
                width:450,
                height:250
            }, { data:rec.data, estado_destino: res.argument.estado }, this.idContenedor,'AntFormEstadoWf',
            {
                config:[{
                          event:'beforesave',
                          delegate: this.onAntEstado,
                        }
                        ],
               scope:this
             })
   },
   
   onAntEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            operacion=  resp.estado_destino == 'inicio'?'inicio':operacion; 
            Ext.Ajax.request({
                url:'../../sis_adquisiciones/control/Solicitud/anteriorEstadoSolicitud',
                params:{
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf:  resp.id_estado_wf,  
                        obs: resp.obs,
                        operacion: operacion,
                        id_solicitud: resp.data.id_solicitud
                 },
                argument:{wizard:wizard},  
                success: this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
           
     },
     
   successEstadoSinc:function(resp){
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
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
