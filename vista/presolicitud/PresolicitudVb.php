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
    	this.addButton('apr_requerimiento',{text:'Aprobar',iconCls: 'bok',disabled:true,handler:this.apr_requerimiento,tooltip: '<b>Aprobar </b><p>Aprobar el inicio de compra</p>'});
        this.iniciarEventos();
        this.init();
        this.store.baseParams={tipo_interfaz:this.nombreVista};
		this.load({params:{start:0, limit:this.tam_pag}});
		
		
	},
    apr_requerimiento:function()
        {                   
           var d= this.sm.getSelected().data;
           Phx.CP.loadingShow();
           Ext.Ajax.request({
               
                url:'../../sis_adquisiciones/control/Presolicitud/aprobarPresolicitud',
                params:{id_presolicitud:d.id_presolicitud,operacion:'aprobado'},
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
               
               this.reload();
                
            }else{
                
                alert('ocurrio un error durante el proceso')
            }
           
            
      },
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
        Phx.vista.Presolicitud.superclass.preparaMenu.call(this,n);
        if(data.estado=='pendiente'){
         this.getBoton('apr_requerimiento').enable();
        
        }
        else{
          this.getBoton('apr_requerimiento').disable();
        }
        this.getBoton('ant_estado').enable();
       
         return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.Presolicitud.superclass.liberaMenu.call(this);
        if(tb){
           
            this.getBoton('apr_requerimiento').disable();
            this.getBoton('ant_estado').disable(); 
                       
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
