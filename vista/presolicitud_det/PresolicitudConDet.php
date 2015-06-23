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
Phx.vista.PresolicitudConDet = {
    bsave:false,
    bnew:false,
    bdel:false,
	require:'../../../sis_adquisiciones/vista/presolicitud_det/PresolicitudDet.php',
	requireclase:'Phx.vista.PresolicitudDet',
	title:'PresolicitudDet',
	nombreVista: 'presolicitudReqDet',
	CheckSelectionModel:true,
	
	constructor: function(config) {
	    
	    this.maestro=config.maestro;
	    Phx.vista.PresolicitudConDet.superclass.constructor.call(this,config);
	    this.init();
	    this.addButton('add_detalle',{text:'Consolidar',iconCls: 'bok',disabled:true,handler:this.addDetalle,tooltip: '<b>Adicionar </b><p>Adicionar a la solicitud de compra</p>'});
        
        
        this.sm.on('beforerowselect',function(a,b,c,rec){
          if(rec.data.estado =='consolidado'){
              
              return false;
          }         
             
        },this
        )     
    
    
    },
	
    
     preparaMenu:function(n){
         
         
         Phx.vista.PresolicitudConDet.superclass.preparaMenu.call(this,n); 
         this.getBoton('add_detalle').enable();
        
          
        
          
     },
     
     liberaMenu: function() {
         Phx.vista.PresolicitudConDet.superclass.liberaMenu.call(this); 
         this.getBoton('add_detalle').disable();
    },
    addDetalle:function(){
        var filas=this.sm.getSelections();
        var cad ='';
        //arma una matriz de los identificadores de registros que se van a pagar
        var sw =0;
        for(var i=0; i<filas.length; i++){
            
            if(filas[i].data.estado == 'pendiente'){
                if(sw==0){
                   cad= filas[i].data[this.id_store];
                   sw=1; 
                }
                else{
                   cad=cad+','+filas[i].data[this.id_store]; 
                }
            }
        }
        var solMaestro = this.obtenerSolicitud();
        if (solMaestro!='no_seleccionado'){
            if( solMaestro!='no_borrador'){
                
               Phx.CP.loadingShow();
               Ext.Ajax.request({
                   
                    url:'../../sis_adquisiciones/control/Presolicitud/consolidarSolicitud',
                    params:{ 
                            id_presolicitud:this.maestro.id_presolicitud,
                            id_presolicitud_dets:cad,
                            id_solicitud:solMaestro
                            },
                    success:this.successSinc,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });
                
            }else{
                alert('La solicitud tiene que estar en estado borrador')
            }
        }
        else{
            alert('selecione una solicitud en estado borrador')
            
        }
    },
    obtenerSolicitud:function(){
        return Phx.CP.getPagina(this.idContenedorPadre).obtenerSolicitud();
    },
    successSinc:function(resp){
            
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        if(!reg.ROOT.error){
           
           this.actualizarSolicitudDet();
           Phx.CP.getPagina(this.idContenedorPadre).reload();
            
        }else{
            alert('ocurrio un error durante el proceso')
        }
    },
    actualizarSolicitudDet:function(){
      
     Phx.CP.getPagina(this.idContenedorPadre).actualizarSolicitudDet();  
        
    }
    
};
</script>
