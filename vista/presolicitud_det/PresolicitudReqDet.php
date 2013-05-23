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
Phx.vista.PresolicitudReqDet = {
    bsave:false,
	require:'../../../sis_adquisiciones/vista/presolicitud_det/PresolicitudDet.php',
	requireclase:'Phx.vista.PresolicitudDet',
	title:'PresolicitudDet',
	nombreVista: 'presolicitudReqDet',
	
	constructor: function(config) {
	    
	    this.maestro=config.maestro;
	    Phx.vista.PresolicitudReqDet.superclass.constructor.call(this,config);
	    this.init();
	    this.iniciarEventos();
    },
	
    
     preparaMenu:function(n){
         Phx.vista.PresolicitudReqDet.superclass.preparaMenu.call(this,n); 
          
         if(this.maestro.estado == 'borrador'){
               this.getBoton('edit').enable();
               this.getBoton('new').enable();
               this.getBoton('del').enable();
         }
         else{
               this.getBoton('edit').disable();
               this.getBoton('new').disable();
               this.getBoton('del').disable();
          }
      },
     
     liberaMenu: function() {
         Phx.vista.PresolicitudReqDet.superclass.liberaMenu.call(this); 
           if(this.maestro&&(this.maestro.estado !=  'borrador')){
               
               this.getBoton('edit').disable();
               this.getBoton('new').disable();
               this.getBoton('del').disable();
         }
         else{
              this.getBoton('edit').disable();
               this.getBoton('new').enable();
               this.getBoton('del').disable();
             
         }
    },
    
    onButtonNew:function(){
        Phx.vista.PresolicitudReqDet.superclass.onButtonNew.call(this);
        this.Cmp.id_concepto_ingas.disable();    
    },
     
    onButtonEdit:function(){
       Phx.vista.PresolicitudReqDet.superclass.onButtonEdit.call(this);
       this.Cmp.id_concepto_ingas.disable();      
    },
    
    
    iniciarEventos:function(){
        
        this.Cmp.id_centro_costo.on('select',function(cmb,rec,ind){
            this.Cmp.id_concepto_ingas.store.baseParams.id_centro_costo = rec.data.id_centro_costo;
            this.Cmp.id_concepto_ingas.enable();
             this.Cmp.id_concepto_ingas.reset();
            this.Cmp.id_concepto_ingas.modificado=true;
            
        },this);
        
        
    }
    
};
</script>
