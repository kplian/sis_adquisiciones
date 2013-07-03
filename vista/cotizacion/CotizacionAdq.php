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
Phx.vista.CotizacionAdq = {
    require:'../../../sis_adquisiciones/vista/cotizacion/Cotizacion.php',
    requireclase:'Phx.vista.Cotizacion',
    title:'Solicitud',
    nombreVista: 'CotizacionAdq',
    
    constructor: function(config) {
        
        
          Phx.vista.CotizacionAdq.superclass.constructor.call(this,config);
          
         
        
         this.addButton('fin_registro',{text:'Fin Reg.',iconCls: 'badelante',disabled:true,handler:this.fin_registro,tooltip: '<b>Finalizar</b><p>Finalizar registro de cotización</p>'});
         
         
         this.addButton('btnAdjudicar',{
                    text :'Recomendar',
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onAdjudicarTodo,
                    tooltip : '<b>Recomedar Todo</b><br/><b>Recomienda la adjudicación de todo lo disponible</b>'
          });
          
           this.addButton('btnSolApro',{text:'Sol. Apro.',iconCls: 'bok',disabled:true,handler:this.onSolAprobacion,tooltip: '<b>Solictar Aprobación</b><p>Solictar Aprobación del RPC</p>'});
           
        
       
        
        this.addButton('btnHabPago',{
                    text :'Habilitar Pago',
                    iconCls : 'bcharge',
                    disabled: true,
                    handler : this.onHabPag,
                    tooltip : '<b>Habilitar Pago</b><br/><b> Permite solicitar pagos en el modulo de cuentar por pagar</b>'
          });
          
          
       this.addButton('btnSendMail',{text:'Sol Cotizacion',iconCls: 'bemail',disabled:true,handler:this.onSendMail,tooltip: '<b>Solictar Cotizacion</b><p>Solicta la cotizacion por correo al proveedor</p>'});
           
        
        
        this.init();
        this.iniciarEventos();
        
        
        
        //formulario de departamentos
        
        this.formDEPTO = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
            layout: 'form',
            items: [
                   {
                    xtype: 'combo',
                    name: 'id_depto_tes',
                     hiddenName: 'id_depto_tes',
                    fieldLabel: 'DEP TESORERIA',
                    allowBlank: false,
                    emptyText:'Elija un Depto',
                    store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_adquisiciones/control/Cotizacion/listarDeptoFiltradoCotizacion',
                        id: 'id_depto',
                        root: 'datos',
                        sortInfo:{
                            field: 'deppto.nombre',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_depto','nombre'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'deppto.nombre#deppto.codigo',estado:'activo',codigo_subsistema:'TES',tipo_filtro:'DEP_EP-DEP_EP'}
                    }),
                    valueField: 'id_depto',
                    displayField: 'nombre',
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p></div></tpl>',
                    hiddenName: 'id_depto_tes',
                    forceSelection:true,
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:10,
                    queryDelay:1000,
                    width:250,
                    listWidth:'280',
                    minChars:2
                }
                  ]
        });
        
        this.cmpDeptoTes =this.formDEPTO.getForm().findField('id_depto_tes');
        
        this.wDEPTO= new Ext.Window({
            title: 'Depto Tesoreria',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 400,
            height: 200,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formDEPTO,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.onSubmitHabPag,
                scope:this
                
            },{
                text: 'Cancelar',
                handler:function(){this.wDEPTO.hide()},
                scope:this
            }]
        }); 
        
      
        this.store.baseParams={id_proceso_compra:this.id_proceso_compra,tipo_interfaz:this.nombreVista}; 
        this.load({params:{start:0, limit:this.tam_pag}});
        
        
    },
    
    EnableSelect:function(n){
         Phx.vista.Cotizacion.superclass.EnableSelect.call(this,n,{desc_moneda_sol:this.desc_moneda});
    },
    
    onButtonNew:function(){         
            Phx.vista.Cotizacion.superclass.onButtonNew.call(this);
            
            this.cmbMoneda.disable();
            this.cmpTipoCambioConv.disable();
         
            this.getComponente('id_proceso_compra').setValue(this.id_proceso_compra);           
    },
    

    
    iniciarEventos:function(){
          this.cmbMoneda= this.getComponente('id_moneda');
          this.cmpFechaCoti =  this.getComponente('fecha_coti');
          this.cmpTipoCambioConv =  this.getComponente('tipo_cambio_conv');
          this.cmbMoneda.disable();
          this.cmpTipoCambioConv.disable();
          
          this.cmpFechaCoti.on('blur',function(){
               this.cmbMoneda.enable();
               this.cmbMoneda.reset();
               this.cmpTipoCambioConv.reset();
               
          },this);
         
          this.cmbMoneda.on('select',function(com,dat){
              
              if(dat.data.tipo_moneda=='base'){
                 this.cmpTipoCambioConv.disable();
                 this.cmpTipoCambioConv.setValue(1); 
                  
              }
              else{
                   this.cmpTipoCambioConv.enable()
                 this.obtenerTipoCambio();  
              }
             
              
          },this);
       
    },
    obtenerTipoCambio:function(){
         
         var fecha = this.cmpFechaCoti.getValue().dateFormat(this.cmpFechaCoti.format);
         var id_moneda = this.cmbMoneda.getValue();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_parametros/control/TipoCambio/obtenerTipoCambio',
                    params:{fecha:fecha,id_moneda:id_moneda},
                    success:this.successTC,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
             });
        }, 
    successTC:function(resp){
       Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
                this.cmpTipoCambioConv.setValue(reg.ROOT.datos.tipo_cambio);
            }else{
                
                alert('ocurrio al obtener el tipo de Cambio')
            } 
    },
    fin_registro:function()
        {                   
            var d= this.sm.getSelected().data;
           
            Phx.CP.loadingShow();
            
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Cotizacion/finalizarRegistro',
                params:{id_cotizacion:d.id_cotizacion,operacion:'fin_registro'},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
        },
        
        onSolAprobacion:function()
        {                   
            var d= this.sm.getSelected().data;
           
            Phx.CP.loadingShow();
            
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Cotizacion/solicitarAprobacion',
                params:{id_cotizacion:d.id_cotizacion,operacion:'sol_apro'},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
        },
     
        
        onAdjudicarTodo:function(){
            var data = this.getSelectedData();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Cotizacion/adjudicarTodo',
                params:{id_cotizacion:data.id_cotizacion},
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
                this.wDEPTO.hide();
                this.reload();
             }else{
                alert('ocurrio un error durante el proceso')
            }
        },
        
       
        

        
                                

        onHabPag:function(){
           
            var data = this.getSelectedData();
            this.cmpDeptoTes.reset();
            this.cmpDeptoTes.store.baseParams.id_cotizacion = data.id_cotizacion;
            this.cmpDeptoTes.modificado = true;
            this.wDEPTO.show();
            
        },
        
        onSubmitHabPag:function(){
            var data = this.getSelectedData();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_adquisiciones/control/Cotizacion/habilitarPago',
                params:{id_cotizacion:data.id_cotizacion,id_depto_tes: this.cmpDeptoTes.getValue()},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        },
        

       
       
        
        preparaMenu:function(n){
          var data = this.getSelectedData();
          var tb =this.tbar;
          Phx.vista.Cotizacion.superclass.preparaMenu.call(this,n); 
          this.getBoton('btnReporte').enable();

          //this.getBoton('btnReporte').enable(); 
              
              if(data['estado']==  'borrador'){
                 this.getBoton('fin_registro').enable();
                 this.getBoton('btnAdjudicar').disable();
                 this.getBoton('btnSolApro').disable();
                 this.getBoton('ant_estado').disable();
                 this.getBoton('btnRepOC').disable();
                 
                 if(data.email != '' &&data.email != undefined){ 
                   this.getBoton('btnSendMail').enable(); 
                 }
               }
              else{
                   this.getBoton('ant_estado').enable();
                   this.getBoton('btnSendMail').disable(); 
                   
                   if(data['estado']=='cotizado'){
                     this.getBoton('btnAdjudicar').enable();
                     this.getBoton('btnSolApro').enable();
                     this.getBoton('btnRepOC').disable();   
                   }
                   else{
                      this.getBoton('btnAdjudicar').disable(); 
                      this.getBoton('btnSolApro').disable();
                      this.getBoton('btnRepOC').enable();
                   }
                  
                   this.getBoton('fin_registro').disable();
                   this.getBoton('edit').disable();
                   this.getBoton('new').disable();
                 }
               
               if (data['estado']==  'borrador'||data['estado']=='cotizado'||data['estado']== 'adjudicado'){
                   
                    this.getBoton('del').enable();
               }
               else{
                   
                    this.getBoton('del').disable();
               }
               
               if (data['estado']==  'anulado'){
                   this.getBoton('ant_estado').disable();
                   //this.getBoton('btnReporte').disable();
                   
               }
               
               if (data['estado']!='adjudicado'){
                   this.getBoton('btnHabPago').disable();
               }
               else{
                    this.getBoton('btnHabPago').enable();  
               }
                 
               if (data['estado']=='pago_habilitado'){
                   this.getBoton('ant_estado').disable();
               }
               
               if (data['estado']=='recomendado'){
                   this.getBoton('btnRepOC').disable();
               }
               
            return tb 
     }, 
     
    
     
     liberaMenu:function(){
        var tb = Phx.vista.Cotizacion.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('fin_registro').disable();
            this.getBoton('btnAdjudicar').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('btnReporte').disable();
            this.getBoton('btnSendMail').disable(); 
         }
       return tb
    },
    
    onSendMail:function(){
        
       Phx.CP.loadingShow();
        
        var rec=this.sm.getSelected();
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Cotizacion/sendMailCotizacion',
                    params:{id_cotizacion:rec.data.id_cotizacion,
                            id_proceso_compra:rec.data.id_proceso_compra,
                            total:'unitario',
                            tipo:rec.data.estado,
                            email:rec.data.email},
                    success: this.successMail,
                    failure: this.conexionFailure,
                    scope:this
                }); 
        
        
    },
    
      successMail:function(resp){
            Phx.CP.loadingHide();
           
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                alert('Correo enviado con exito')
             }else{
                alert('ocurrio un error durante el proceso')
            }
        }
        
    
    
};
</script>
