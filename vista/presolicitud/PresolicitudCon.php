<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
	ISSUE		FECHA:	         AUTOR:				 DESCRIPCION:	
 * #4 endeETR  	19/02/2019       EGS                 -aumento el campo asignados, boton y funciones para FlujoWF, se agrego grupo de barras aprobado y finalizado
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresolicitudCon = {
	require:'../../../sis_adquisiciones/vista/presolicitud/Presolicitud.php',
	requireclase:'Phx.vista.Presolicitud',
	title:'Presolicitud',
	nombreVista: 'PresolicitudCon',
	//#4
	gruposBarraTareas:[{name:'aprobado',title:'<H1 align="center"><i class="fa fa-thumbs-o-up"></i> Aprobados</h1>',grupo:0,height:0},
                       {name:'finalizado',title:'<H1 align="center"><i class="fa fa-check"></i> Finalizados</h1>',grupo:0,height:0}],
	actualizarSegunTab: function(name, indice){
		this.store.baseParams.estado = name;
    	if(this.finCons){
    		 this.store.baseParams.estado = name;
    	     this.load({params:{start:0, limit:this.tam_pag}});
    	   }
    },//#4
    
	
	constructor: function(config) {
		this.unirAtributos(); //ejecutamos primero para que los atributos extra se carguen y visualizaen //#4
    	Phx.vista.PresolicitudCon.superclass.constructor.call(this,config);
        this.addButton('sig_estado',{ text:'Finalizar', iconCls: 'badelante', disabled: true, handler: this.siguienteEstado, tooltip: '<b>Pasar al Siguiente Estado</b>'});  //#4
        this.iniciarEventos();
        this.init();
        this.store.baseParams={tipo_interfaz:this.nombreVista};
		this.load({params:{start:0, limit:this.tam_pag ,estado :'aprobado'}});//#4
		this.finCons = true;//#4
		
	},

    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
        Phx.vista.PresolicitudCon.superclass.preparaMenu.call(this,n);
        this.getBoton('diagrama_gantt').enable();
        
        if(data.estado=='asignado'){
         this.getBoton('sig_estado').enable();
        
        }
        else{
          this.getBoton('sig_estado').disable();
          
        }
        /*
       if(data.estado=='finalizado'){

        this.getBoton('ant_estado').disable();
       }
       else{*/
       	this.getBoton('ant_estado').enable();
      // }
        this.getBoton('btnReporte').enable();  
         return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.PresolicitudCon.superclass.liberaMenu.call(this);
        if(tb){
           	this.getBoton('diagrama_gantt').disable();
            this.getBoton('sig_estado').disable();
            this.getBoton('ant_estado').disable(); 
            this.getBoton('btnReporte').disable();             
        }
       return tb
    },
    obtenerSolicitud:function(){
       return Phx.CP.getPagina(this.idContenedorPadre).obtenerSolicitud();   
    },	
    actualizarSolicitudDet:function(){
      
     Phx.CP.getPagina(this.idContenedorPadre).actualizarSolicitudDet();  
        
    },
    
	south:
          { 
          url:'../../../sis_adquisiciones/vista/presolicitud_det/PresolicitudConDet.php',
          title:'Detalle', 
          height:'50%',
          cls:'PresolicitudConDet'
         },
         bsave:false,
         bnew:false,
         bdel:false,
         bedit:false,
    //#4     
    unirAtributos: function (){
    	var me = this;
    	this.Atributos = this.extraAtributos.concat(me.Atributos);
    	this.fields = this.fields.concat(me.extraFields);
    },
    //#4
    extraAtributos:[
    	{
            config:{
                name: 'asignado',
                fieldLabel: 'Nro. Items Asignados',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:30
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },    
    ],
    //#4
    extraFields:[
    {name:'asignado', type: 'string'}  
    ], 
};
</script>
