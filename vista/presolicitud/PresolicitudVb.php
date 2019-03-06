<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresolicitudVb = {
	require:'../../../sis_adquisiciones/vista/presolicitud/Presolicitud.php',
	requireclase:'Phx.vista.Presolicitud',
	title:'Presolicitud',
	nombreVista: 'PresolicitudVb',
	
	constructor: function(config) {
    	Phx.vista.PresolicitudVb.superclass.constructor.call(this,config);
        
        this.addButton('sig_estado',{ text:'Aprobar', iconCls: 'bok', disabled: true, handler: this.sigEstado, tooltip: '<b>Pasar al Siguiente Estado</b>'});
        this.iniciarEventos();
        this.init();
        this.store.baseParams={tipo_interfaz:this.nombreVista};
		this.load({params:{start:0, limit:this.tam_pag}});
		
		
	},
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
        Phx.vista.Presolicitud.superclass.preparaMenu.call(this,n);
        this.getBoton('diagrama_gantt').enable();
        if(data.estado=='pendiente'){
         this.getBoton('sig_estado').enable();       
        }
        else{
          this.getBoton('sig_estado').disable();

        }
        this.getBoton('ant_estado').enable();
        this.getBoton('btnReporte').enable();  
         return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.Presolicitud.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable(); 
            this.getBoton('btnReporte').disable();            
        }
       return tb
    },
	south:
          { 
          url:'../../../sis_adquisiciones/vista/presolicitud_det/PresolicitudReqDet.php',
          title:'Detalle', 
          height:'50%',
          cls:'PresolicitudReqDet'
         },
         bsave:false,
         bnew:false,
         bdel:false,
         bedit:false
};
</script>
