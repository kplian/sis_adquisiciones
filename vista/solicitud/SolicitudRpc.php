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
    	this.addButton('ini_estado',{  argument: {estado: 'inicio'},text:'Dev. a Borrador',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Cabiar RPC</b>'});
        
        
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
       
      return tb 
  }, 
   liberaMenu:function(){
        var tb = Phx.vista.SolicitudRpc.superclass.liberaMenu.call(this);
        
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
       
	
	
};
</script>
