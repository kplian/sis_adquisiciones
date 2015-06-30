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
Phx.vista.SolicitudRpc = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_adquisiciones/vista/solicitud/Solicitud.php',
	requireclase:'Phx.vista.Solicitud',
	title:'Solicitud',
	nombreVista: 'solicitudRpc',
	
	constructor: function(config) {
	    
	    this.maestro=config.maestro;
	    
	    this.Atributos.unshift({
            config:{
                name: 'ai_habilitado',
                fieldLabel: 'Sup.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 50,
                renderer:function (value,p,record){
                    if(value=='no'){
                        return String.format('<font color="green">{0}</font>', value);
                    }
                    else{
                        return String.format('<font color="red">{0}</font>', value);
                    }
                    
                },
                maxLength:2
            },
            type:'Field',
            filters:{pfiltro:'sol.ai_habilitado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        });
	    
	    
	    this.Atributos[this.getIndAtributo('id_funcionario')].form=false;
        this.Atributos[this.getIndAtributo('id_funcionario_aprobador')].form=false;
        this.Atributos[this.getIndAtributo('id_moneda')].form=false;
        //this.Atributos[this.getIndAtributo('id_proceso_macro')].form=false;
        this.Atributos[this.getIndAtributo('fecha_soli')].form=false;
        this.Atributos[this.getIndAtributo('id_categoria_compra')].form=false;
        this.Atributos[this.getIndAtributo('id_uo')].form=false;
        this.Atributos[this.getIndAtributo('id_depto')].form=false;
        
        
        this.Atributos[this.getIndAtributo('num_tramite')].config.renderer = function (value, p, record){
                                                                             if(record.data['ai_habilitado']=='si'){
                                                                                 return String.format('<font color="red">{0}</font>', record.data['num_tramite']);
                                                                             }
                                                                             else{
                                                                                 return String.format('<font color="green">{0}</font>', record.data['num_tramite']);
                                                                             }
                                                                          }
        
        
        //funcionalidad para listado de historicos
        this.historico = 'no';
        
        Phx.vista.SolicitudRpc.superclass.constructor.call(this,config);
    	this.addButton('change_rpc',{  argument: {estado: 'inicio'},text:'Cabiar RPC',iconCls: 'blist',disabled:true,handler:this.changeRpc,tooltip: '<b>Cabiar RPC</b>'});
        
        
        //si la interface es pestanha este código es para iniciar 
          var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
          if(dataPadre){
             this.onEnablePanel(this, dataPadre);
          }
          else
          {
             this.bloquearMenus();
          }
        
       
        
        
		
	},
	
  preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.SolicitudRpc.superclass.preparaMenu.call(this,n); 
       if(data.estado !='finalizado' || data.estado !='cancelado' ||data.estado !='anulado'){ 
          this.getBoton('change_rpc').enable(); 
       }
        else{
           this.getBoton('change_rpc').disable();     
       }
          
       //habilitar reporte de colicitud de comrpa y preorden de compra
       this.menuAdq.enable();
       
      return tb 
  }, 
   liberaMenu:function(){
        var tb = Phx.vista.SolicitudRpc.superclass.liberaMenu.call(this);
        if(tb){
             this.getBoton('change_rpc').disable(); 
             //boton de reporte de solicitud y preorden de compra
            this.menuAdq.disable();
        }
        return tb
  },
  
  onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={
              id_cargo:this.maestro.id_cargo,
              id_cargo_ai:this.maestro.id_cargo_ai,
              tipo_interfaz:this.nombreVista
              
              };
        
        this.load({params:{start:0, limit:50}})
   },  
   
   changeRpc:function(){
         var rec=this.sm.getSelected();
         if(rec){
             
            Phx.CP.loadingShow();
            
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Rpc/changeRpc',
                params:{
                    'id_solicitud':rec.data.id_solicitud
                  },
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
                alert(reg.ROOT.detalle.mensaje)
                
            }else{
                
                alert('ocurrio un error durante el proceso')
            }
         
          this.reload();
            
     },    
       
	
	
};
</script>
