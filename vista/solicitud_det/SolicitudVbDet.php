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
Phx.vista.SolicitudVbDet = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_adquisiciones/vista/solicitud_det/SolicitudDet.php',
	requireclase:'Phx.vista.SolicitudDet',
	title:'Solicitud',
	nombreVista: 'solicitudVbDet',
	
	constructor: function(config) {
	    
	    this.maestro=config.maestro;
	   // this.Atributos[this.getIndAtributo('id_centro_costo')].form=false;
        this.Atributos[this.getIndAtributo('id_orden_trabajo')].form=false;
        //this.Atributos[this.getIndAtributo('id_concepto')].form=false;
        Phx.vista.SolicitudVbDet.superclass.constructor.call(this,config);
    },
	onReloadPage:function(m){
       this.maestro=m;
       this.store.baseParams={id_solicitud:this.maestro.id_solicitud};
       this.load({params:{start:0, limit:this.tam_pag}});
              
       this.cmpPrecioUnitario.currencyChar = this.maestro.desc_moneda+' ';   
       this.cmpPrecioTotal.currencyChar = this.maestro.desc_moneda+' ';
       this.cmpCantidad.currencyChar = this.maestro.desc_moneda+' ';
       this.cmpPrecioSg.currencyChar = this.maestro.desc_moneda+' ';
       this.cmpPrecioGa.currencyChar = this.maestro.desc_moneda+' ';
         
       this.setColumnHeader('precio_unitario', this.cmpPrecioUnitario.fieldLabel +' '+this.maestro.desc_moneda)
       this.setColumnHeader('precio_total', this.cmpPrecioTotal.fieldLabel +' '+this.maestro.desc_moneda)
       this.setColumnHeader('precio_sg', this.cmpPrecioSg.fieldLabel +' '+this.maestro.desc_moneda)
       this.setColumnHeader('precio_ga', this.cmpPrecioGa.fieldLabel +' '+this.maestro.desc_moneda)
        
    },
    
    iniciarEventos:function(){
         this.cmpPrecioUnitario= this.getComponente('precio_unitario');
         this.cmpPrecioTotal = this.getComponente('precio_total');
         this.cmpCantidad = this.getComponente('cantidad');
         this.cmpPrecioSg = this.getComponente('precio_sg');
         this.cmpPrecioGa = this.getComponente('precio_ga');
    
    }
};
</script>
