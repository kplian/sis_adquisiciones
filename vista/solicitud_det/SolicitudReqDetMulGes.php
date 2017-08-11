<?php
/**
*@package pXP
*@file SolicitudReqDetMulGes.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudReqDetMulGes = {
   /* bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,*/
	require:'../../../sis_adquisiciones/vista/solicitud_det/SolicitudDet.php',
	requireclase:'Phx.vista.SolicitudDet',
	title:'Solicitud',
	nombreVista: 'solicitudDetVb',
	
	constructor: function(config) {
		
		this.Atributos[this.getIndAtributo('precio_sg')].config.inputType=undefined; 
	    
	    this.maestro=config.maestro;
	    Phx.vista.SolicitudReqDetMulGes.superclass.constructor.call(this,config);
    },
	onReloadPage:function(m){
		
       this.maestro=m;
       
       this.store.baseParams={id_solicitud:this.maestro.id_solicitud};
       
       this.Cmp.id_centro_costo.store.baseParams.id_gestion=this.maestro.id_gestion;
       this.Cmp.id_centro_costo.store.baseParams.codigo_subsistema='ADQ';
       this.Cmp.id_centro_costo.store.baseParams.id_depto =this.maestro.id_depto;
       this.Cmp.id_centro_costo.modificado=true;
       
       //cuando esta el la inteface de presupeustos no filtra por bienes o servicios
       if(this.maestro.estado == 'vbpresupuestos'){
       	delete this.Cmp.id_concepto_ingas.store.baseParams.tipo;
       }
       else{
       	this.Cmp.id_concepto_ingas.store.baseParams.tipo=this.maestro.tipo;
       }
       
       
       this.Cmp.id_concepto_ingas.store.baseParams.id_gestion=this.maestro.id_gestion;
       this.Cmp.id_concepto_ingas.modificado = true;
       
       this.load({params:{start:0, limit:50}});
       
       
       
              
       
       this.setColumnHeader('precio_unitario', this.cmpPrecioUnitario.fieldLabel +' '+this.maestro.desc_moneda)
       this.setColumnHeader('precio_total', this.cmpPrecioTotal.fieldLabel +' '+this.maestro.desc_moneda)
       this.setColumnHeader('precio_sg', this.cmpPrecioSg.fieldLabel +' '+this.maestro.desc_moneda)
       this.setColumnHeader('precio_ga', this.cmpPrecioGa.fieldLabel +' '+this.maestro.desc_moneda)
        
         if(this.maestro.estado ==  'borrador' || this.maestro.estado ==  'Borrador'){
             
             this.getBoton('new').enable();
             
         }
         else{
             
             this.getBoton('edit').disable();
             this.getBoton('new').disable();
             this.getBoton('del').disable();
          }
     },
    
     preparaMenu:function(n){
         
         Phx.vista.SolicitudReqDetMulGes.superclass.preparaMenu.call(this,n); 
          if(this.maestro.estado ==  'borrador' || this.maestro.estado ==  'vbpresupuestos' ||this.maestro.estado==  'Borrador'){
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
         Phx.vista.SolicitudReqDetMulGes.superclass.liberaMenu.call(this); 
           if(this.maestro&&(this.maestro.estado !=  'borrador')){
               
               this.getBoton('edit').disable();
               this.getBoton('new').disable();
               this.getBoton('del').disable();
         }
    },
    
    onButtonEdit:function(){
	    
	  Phx.vista.SolicitudReqDetMulGes.superclass.onButtonEdit.call(this);
	  this.Cmp.id_orden_trabajo.allowBlank = true;
	  this.Cmp.id_orden_trabajo.disable();
	},
	
	onButtonNew:function(){
	    
	  Phx.vista.SolicitudReqDetMulGes.superclass.onButtonNew.call(this);
	  this.Cmp.id_orden_trabajo.allowBlank = true;
	  this.Cmp.id_orden_trabajo.disable();  
	  
	},
    
    
	iniciarEventos:function(){
         this.cmpPrecioUnitario= this.getComponente('precio_unitario');
         this.cmpPrecioTotal = this.getComponente('precio_total');
         this.cmpCantidad = this.getComponente('cantidad');
         this.cmpPrecioSg = this.getComponente('precio_sg');
         this.cmpPrecioGa = this.getComponente('precio_ga');
         
        this.cmpPrecioUnitario.on('change',function(field){
             var pTot = this.cmpCantidad.getValue() *this.cmpPrecioUnitario.getValue();
             this.cmpPrecioTotal.setValue(pTot);
              this.cmpPrecioGa.setValue(pTot);
             this.cmpPrecioSg.setValue(0)
             console.log('coloca cero....');
             
        } ,this);
        
       this.cmpCantidad.on('change',function(field){
            var pTot = this.cmpCantidad.getValue() * this.cmpPrecioUnitario.getValue();
            this.cmpPrecioTotal.setValue(pTot);
             this.cmpPrecioGa.setValue(pTot);
             this.cmpPrecioSg.setValue(0);
            
        } ,this);
        
         this.cmpPrecioSg.on('valid',function(field){
            
            this.cmpPrecioGa.setValue(this.cmpPrecioTotal.getValue() -this.cmpPrecioSg.getValue());
            
        } ,this);
        
        
         this.Cmp.id_concepto_ingas.on('change',function( cmb, rec, ind){
	        	    this.Cmp.id_orden_trabajo.reset();
	           },this);
	        
	     this.Cmp.id_concepto_ingas.on('select',function( cmb, rec, ind){
	        	
	        	    this.Cmp.id_orden_trabajo.store.baseParams = Ext.apply(this.Cmp.id_orden_trabajo.store.baseParams, {
			        		                                           filtro_ot:rec.data.filtro_ot,
			        		 										   requiere_ot:rec.data.requiere_ot,
			        		 										   id_grupo_ots:rec.data.id_grupo_ots
			        		 										});
			        this.Cmp.id_orden_trabajo.modificado = true;
			        this.Cmp.id_orden_trabajo.enable();
			        if(rec.data.requiere_ot =='obligatorio'){
			        	this.Cmp.id_orden_trabajo.allowBlank = false;
			        }
			        else{
			        	this.Cmp.id_orden_trabajo.allowBlank = true;
			        }
			        this.Cmp.id_orden_trabajo.reset();
			        this.Cmp.id_orden_trabajo.enable();
        	
             },this);
	    
        
     }
   
};
</script>
