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
Phx.vista.SolicitudVbAsistente = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_adquisiciones/vista/solicitud/Solicitud.php',
	requireclase:'Phx.vista.Solicitud',
	title:'Solicitud',
	nombreVista: 'solicitudVbAsistente',
	
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
        this.Atributos[this.getIndAtributo('revisado_asistente')].grid=true; 
        
        //funcionalidad para listado de historicos
        this.historico = 'no';
        this.tbarItems = ['-',{
            text: 'Histórico',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                     this.historico = 'si';
                    
                }
                else{
                   this.historico = 'no' 
                }
                
                this.store.baseParams.historico = this.historico;
                this.reload();
             },
            scope: this
           }];
        
    	Phx.vista.SolicitudVbAsistente.superclass.constructor.call(this,config);
    	   
        this.addButton('btnRev', {
                text : 'Revisado',
                iconCls : 'bball_green',
                disabled : true,
                handler : this.cambiarRev,
                tooltip : '<b>Revisado</b><br/>Sirve como un indicador de que la documentacion fue revisada por el asistente'
        });        
       
        this.store.baseParams={tipo_interfaz:this.nombreVista};
        //coloca filtros para acceso directo si existen
        if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
        //carga inicial de la pagina
        this.load({params:{start:0, limit:this.tam_pag}}); 
        
       
        
        
		
	},
	
   cambiarRev:function(){
	    Phx.CP.loadingShow();
	    var d = this.sm.getSelected().data;
        Ext.Ajax.request({
            url:'../../sis_adquisiciones/control/Solicitud/marcarRevisadoSol',
            params:{id_solicitud:d.id_solicitud},
            success:this.successRev,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        }); 
	    
	},
	
	successRev:function(resp){
       Phx.CP.loadingHide();
       var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
       if(!reg.ROOT.error){
         this.reload();
       }
    },
	
     
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.SolicitudVbAsistente.superclass.preparaMenu.call(this,n);  
      var data = this.getSelectedData();
        if(data['revisado_asistente']== 'si'){
            this.getBoton('btnRev').setIconClass('bball_white')
        }
        else{
            this.getBoton('btnRev').setIconClass('bball_green')
        }
       this.getBoton('btnRev').enable();
       //habilitar reporte de colicitud de comrpa y preorden de compra
       this.menuAdq.enable();
       return tb 
    },  
    
    liberaMenu:function(){
        var tb = Phx.vista.SolicitudVbAsistente.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('btnRev').disable();
            //boton de reporte de solicitud y preorden de compra
            this.menuAdq.disable();
           
        }
        return tb
    }, 
	south:
          { 
          url:'../../../sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php',
          title:'Detalle', 
          height:'50%',
          cls:'SolicitudVbDet'
         }
};
</script>
