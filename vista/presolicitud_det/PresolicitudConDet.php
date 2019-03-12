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
	    var estado_maestro;
	    this.unirAtributos(); //ejecutamos primero para que los atributos extra se carguen y visualizaen
	    Phx.vista.PresolicitudConDet.superclass.constructor.call(this,config);
	    this.init();
	    this.addButton('add_detalle',{text:'Consolidar',iconCls: 'bok',disabled:true,handler:this.addDetalle,tooltip: '<b>Adicionar </b><p>Adicionar a la solicitud de compra</p>'});
	    this.addButton('del_detalle',{
	    	text:'Desconsolidar',
	    	iconCls: 'bwrong',
	    	disabled:true,
	    	handler:this.delDetalle,
	    	tooltip: '<b>Quitar </b><p>Quitar de la solicitud de compra</p>'
	    	});
    /*
        this.sm.on('beforerowselect',function(a,b,c,rec){
          if(rec.data.estado =='consolidado'){
              
              return false;
          }         
             
        },this
        )     
    */
    	//this.unirAtributos();
    },
	
    
     preparaMenu:function(n){
         var rec = this.sm.getSelected();
		 console.log('estado_maestro',this.estado_maestro);
         var tb = Phx.vista.PresolicitudConDet.superclass.preparaMenu.call(this,n); 
         if( rec.data.estado == 'consolidado' ){
         	 this.getBoton('add_detalle').disable();
	         this.getBoton('del_detalle').enable();
			         

         }else{
         this.getBoton('add_detalle').enable();
 	      this.getBoton('del_detalle').disable();        
         }
        if (tb && this.bedit && rec.data.estado == 'consolidado') {
            tb.items.get('b-edit-' + this.idContenedor).disable();
            }
        if (this.estado_maestro == 'finalizado') {
        	this.getBoton('del_detalle').disable();	
        };
          
     },
     
     liberaMenu: function() {
         Phx.vista.PresolicitudConDet.superclass.liberaMenu.call(this); 
         this.getBoton('add_detalle').disable();
         this.getBoton('del_detalle').disable();
         
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
    delDetalle:function(){
        var filas=this.sm.getSelections();
        console.log('filas',filas[0].data.id_solicitud)
        var cad ='';
        //arma una matriz de los identificadores de registros que se van a desconsolidar
        var sw =0;
        for(var i=0; i<filas.length; i++){
            
            if(filas[i].data.estado == 'consolidado'){
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
        console.log('solMaestro',solMaestro);
        if (solMaestro!='no_seleccionado'){
            if( solMaestro == filas[0].data.id_solicitud ){
                
               Phx.CP.loadingShow();
               Ext.Ajax.request({
                   
                    url:'../../sis_adquisiciones/control/Presolicitud/desconsolidarSolicitud',
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
                alert('No selecciono la solicitud correcta.Seleccione la solicitud asociada a la Presolicitud')
            }
        }
        else{
            alert('selecione la Solicitud Asociada al detalle')
            
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
        
    },
    unirAtributos: function (){
    	var me = this;
    	this.Atributos = this.extraAtributos.concat(me.Atributos);
    	this.fields = this.fields.concat(me.extraFields);
    },
    extraAtributos:[
    	{
            config:{
                name: 'num_tramite',
                fieldLabel: 'Nro.Tra. ADQ',
                allowBlank: true,
                anchor: '80%',
                gwidth: 200,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'pred.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },    
    ],
    extraFields:[
    {name:'num_tramite', type: 'string'}  
    ],
    postReloadPage:function(data){
    	this.estado_maestro = data.estado;
    },            

    
    
};
</script>
