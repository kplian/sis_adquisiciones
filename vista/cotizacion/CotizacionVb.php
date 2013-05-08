<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (rarteaga)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CotizacionVb = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
    require:'../../../sis_adquisiciones/vista/cotizacion/Cotizacion.php',
    requireclase:'Phx.vista.Cotizacion',
    title:'Cotizacion RPC',
    nombreVista: 'CotizacionVb',
    
    constructor: function(config) {
          this.maestro=config.maestro;
        Phx.vista.CotizacionVb.superclass.constructor.call(this,config);
        
         this.addButton('btnGenOC',{
                    text :'Sol. Aprobacion',
                    iconCls : 'bok',
                    disabled: true,
                    handler : this.onGenOC,
                    tooltip : '<b>Solictar Aprobación RPC</b><br/><b>La recomendación pasa a revisióon del RPC </b>'
          });
          
          
        this.store.baseParams={tipo_interfaz:this.nombreVista}; 
        this.load({params:{start:0, limit:this.tam_pag}});
        
        this.init();
        
        //formulario de adjudicacion parcil
        
        this.formOC = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
            layout: 'form',
            items: [
                   { 
                    xtype: 'datefield',   
                    name: 'fecha_oc',
                    fieldLabel: 'Fecha OC',
                    disabled:true,
                    allowBlank: false
                    
                   }
                  ]
        });
        
        
         this.cmpFechaOC =this.formOC.getForm().findField('fecha_oc');
         
         
         
         this.wOC= new Ext.Window({
            title: 'Generar OC',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 350,
            height: 170,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formOC,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.onSubmitGenOC,
                scope:this
                
            },{
                text: 'Cancelar',
                handler:function(){this.wOC.hide()},
                scope:this
            }]
        });
        
        
    } ,
    ActList:'../../sis_adquisiciones/control/Cotizacion/listarCotizacionRPC',
    
    onGenOC:function(){
            
          this.cmpFechaOC.setValue(new Date());
          this.cmpFechaOC.disable();
          this.wOC.show(); 
            
    },
        
    onSubmitGenOC:function(){
            var data = this.getSelectedData();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_adquisiciones/control/Cotizacion/generarOC',
                params:{id_cotizacion:data.id_cotizacion,fecha_oc: this.cmpFechaOC.getValue().dateFormat('d/m/Y')},
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
                this.wOC.hide(); 
                this.reload();
             }else{
                alert('ocurrio un error durante el proceso')
            }
        },
        
        
        
       preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.CotizacionVb.superclass.preparaMenu.call(this,n);
          
            if(data['estado']==  'recomendado'){
                 this.getBoton('btnGenOC').enable();
                this.getBoton('btnRepOC').disable(); 
              }
            if(data['estado']==  'adjudicado'){
                 this.getBoton('btnGenOC').disable();
                 this.getBoton('btnRepOC').enable(); 
             }   
           this.getBoton('btnReporte').enable();  
           this.getBoton('ant_estado').enable();
         },
          
            
       liberaMenu:function(){
        var tb = Phx.vista.CotizacionVb.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('btnGenOC').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnRepOC').disable(); 
            this.getBoton('btnReporte').disable();  
            
            }
       return tb
      }
        
    
    
};
</script>
