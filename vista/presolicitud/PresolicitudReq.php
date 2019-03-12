<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * ISSUE		FECHA				AUTHOR		DESCRIPCION
 * #4   endeEtr	05/02/2019			EGS			inhabilita edicion y eliminacion en estado diferente a borrador
 * */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PresolicitudReq = {
	require:'../../../sis_adquisiciones/vista/presolicitud/Presolicitud.php',
	requireclase:'Phx.vista.Presolicitud',
	title:'Presolicitud',
	nombreVista: 'PresolicitudReq',
	
	constructor: function(config) {
    	Phx.vista.PresolicitudReq.superclass.constructor.call(this,config);
    	this.addButton('sig_estado',{ text:'Siguiente', iconCls: 'badelante', disabled: true, handler: this.sigEstado, tooltip: '<b>Pasar al Siguiente Estado</b>'});
        this.iniciarEventos();
        this.init();
        this.store.baseParams={tipo_interfaz:this.nombreVista};
		this.load({params:{start:0, limit:this.tam_pag}});
		
		
	},
      
    iniciarEventos:function(){
        
        this.cmpFechaSoli = this.getComponente('fecha_soli');
        this.cmpIdUo = this.getComponente('id_uo');
        this.cmpIdFuncionarioSupervisor = this.getComponente('id_funcionario_supervisor');
        
        //inicio de eventos 
        this.cmpFechaSoli.on('change',function(f){
             this.obtenerGestion(this.cmpFechaSoli);
             this.cmpIdUo.reset();
             this.cmpIdFuncionarioSupervisor.reset();
             this.cmpIdUo.enable();
             this.Cmp.id_funcionario.enable();             
             this.Cmp.id_funcionario.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
             
             },this);
        
        this.Cmp.id_funcionario.on('select',function(rec){ 
            
            /*//Aprobador  
            this.cmpIdFuncionarioSupervisor.store.baseParams.id_funcionario=this.Cmp.id_funcionario.getValue();
            this.cmpIdFuncionarioSupervisor.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
            this.cmpIdFuncionarioSupervisor.modificado=true;*/
           
           
           //Aprobador  
            this.cmpIdFuncionarioSupervisor.store.baseParams.id_funcionario_dependiente=this.Cmp.id_funcionario.getValue();
            this.cmpIdFuncionarioSupervisor.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
            this.cmpIdFuncionarioSupervisor.modificado=true;
            
            //Unidad
            this.Cmp.id_uo.store.baseParams.id_funcionario_uo_presupuesta=this.Cmp.id_funcionario.getValue();
            this.Cmp.id_uo.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
            this.Cmp.id_uo.store.load({params:{start:0,limit:this.tam_pag}, 
               callback : function (r) {                        
                    if (r.length > 0 ) {                        
                        this.Cmp.id_uo.setValue(r[0].data.id_uo);
                    }     
                                    
                }, scope : this
            });
            
            this.cmpIdUo.enable();
            this.cmpIdFuncionarioSupervisor.reset();
            this.cmpIdFuncionarioSupervisor.enable();
            
           },this);
      
    },
     onButtonNew:function(){
       Phx.vista.Presolicitud.superclass.onButtonNew.call(this); 
       
       this.cmpIdFuncionarioSupervisor.disable();
       this.cmpIdUo.disable();
       this.Cmp.id_funcionario.disable();
       this.Cmp.fecha_soli.setValue(new Date());
       this.Cmp.fecha_soli.fireEvent('change');
       
       this.Cmp.id_depto.enable();
       this.Cmp.id_funcionario.enable();
       
       this.Cmp.id_funcionario.store.load({params:{start:0,limit:this.tam_pag}, 
           callback : function (r) {
                if (r.length == 1 ) {                       
                    this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
                    this.Cmp.id_funcionario.fireEvent('select', r[0]);
                }    
                                
            }, scope : this
        });
        
           
    },

    onButtonEdit:function(){
       this.cmpFechaSoli.disable();
       this.cmpIdFuncionarioSupervisor.disable();       
       this.cmpIdUo.disable();
       this.Cmp.id_depto.disable();
       this.Cmp.id_funcionario.disable();
       Phx.vista.PresolicitudReq.superclass.onButtonEdit.call(this);
       this.Cmp.id_funcionario.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
          
    },
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
        Phx.vista.PresolicitudReq.superclass.preparaMenu.call(this,n);
        this.getBoton('diagrama_gantt').enable();
        if(data.estado=='borrador'){
         
         this.getBoton('sig_estado').enable();
         this.getBoton('ant_estado').disable();
         
        }
        else{
          this.getBoton('sig_estado').disable();

          if (data.estado !='borrador'){//#4
               this.getBoton('ant_estado').enable();
               this.getBoton('edit').disable();//#4
               this.getBoton('del').disable();//#4

              
          } 
          else{
               this.getBoton('ant_estado').enable();
              
          }
            
        }
        this.getBoton('btnReporte').enable();  
       
         return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.PresolicitudReq.superclass.liberaMenu.call(this);
        if(tb){
           
            this.getBoton('btnReporte').disable();
            this.getBoton('diagrama_gantt').disable();
             
        }
       return tb
    },
    
     obtenerGestion:function(x){
         
         var fecha = x.getValue().dateFormat(x.format);
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                    // form:this.form.getForm().getEl(),
                    url:'../../sis_parametros/control/Gestion/obtenerGestionByFecha',
                    params:{fecha:fecha},
                    success:this.successGestion,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
             });
        }, 
    successGestion:function(resp){
       Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                
                this.Cmp.id_gestion.setValue(reg.ROOT.datos.id_gestion);
                
               
            }else{
                
                alert('ocurrio al obtener la gestion')
            } 
    },
	
	south:
          { 
          url:'../../../sis_adquisiciones/vista/presolicitud_det/PresolicitudReqDet.php',
          title:'Detalle', 
          height:'50%',
          cls:'PresolicitudReqDet'
         }
};
</script>
