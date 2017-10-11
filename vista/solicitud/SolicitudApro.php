<?php
/**
*@package pXP
*@file gen-SistemaDist.php
*@author  (fprudencio)
*@date 20-09-2011 10:22:05
*@description Archivo con la interfaz de usuario que permite 
*el inico de procesos de compra a partir de las solicitude aprobadas
*
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolicitudApro = {
    bedit:false,
    bnew:false,
    bsave:false,
    bdel:false,
	require:'../../../sis_adquisiciones/vista/solicitud/Solicitud.php',
	requireclase:'Phx.vista.Solicitud',
	title:'Solicitud',
	nombreVista: 'solicitudApro',
	
	
	constructor: function(config) {
	    
	    this.maestro=config.maestro;
	    
	    this.initButtons=[this.cmbDeptoAdq];
	    
	    this.Atributos[this.getIndAtributo('id_funcionario')].form=false;
        this.Atributos[this.getIndAtributo('id_funcionario_aprobador')].form=false;
        this.Atributos[this.getIndAtributo('id_moneda')].form=false;
        //this.Atributos[this.getIndAtributo('id_proceso_macro')].form=false;
        this.Atributos[this.getIndAtributo('fecha_soli')].form=false;
        this.Atributos[this.getIndAtributo('id_categoria_compra')].form=false;
        this.Atributos[this.getIndAtributo('id_uo')].form=false;
        this.Atributos[this.getIndAtributo('id_depto')].form=false;
        
        //funcionalidad para listado de historicos
        this.historico = 'no';
        this.tbarItems = ['-',{
            text: 'En Proceso',
            enableToggle: true,
            pressed: false,
            toggleHandler: function(btn, pressed) {
               
                if(pressed){
                    this.store.baseParams.filtro_solo_aprobadas = 0;
                     
                }
                else{
                   this.store.baseParams.filtro_solo_aprobadas = 1;
                }
                
                this.onButtonAct();
             },
            scope: this
           }];
        this.Atributos.splice(7,0, {
            config:{
                name: 'importe_total',
                fieldLabel: 'Importe',
                allowBlank: false,
                anchor: '80%',
                gwidth: 120,
                maxLength:100,
                renderer:function (value,p,record){

                    Number.prototype.formatDinero = function(c, d, t){
                        var n = this,
                            c = isNaN(c = Math.abs(c)) ? 2 : c,
                            d = d == undefined ? "." : d,
                            t = t == undefined ? "," : t,
                            s = n < 0 ? "-" : "",
                            i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "",
                            j = (j = i.length) > 3 ? j % 3 : 0;
                        return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
                    };

                    return  String.format('<div style="vertical-align:middle;text-align:right; color:green;"><b><span >{0}</span></b></div>',(parseFloat(value)).formatDinero(2, ',', '.'));
                }
            },
            type:'MoneyField',
            grid:true,
            form:false
        });
        
    	Phx.vista.SolicitudApro.superclass.constructor.call(this,config);
    	
    	this.addButton('ini_estado',{  argument: {estado: 'inicio'},text:'Dev. a Borrador',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Retorna la Solcitud al estado borrador</b>'});
        this.addButton('ant_estado',{argument: {estado: 'anterior'},text:'Anterior',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        this.addButton('ini_proc',{text:'Ini Proc',iconCls: 'badelante',disabled:true,handler:this.initProceso,tooltip: '<b>Iniciar un nuevo Proceso</b>'});
        this.addButton('asig_usu',{text:'Asig. Usu.',iconCls:'blist',disabled:true,handler:this.initAsigUsu,tooltip: '<b>Asigna un Usuario encargado del proceso de Compra</b>'});
        
        
        this.init();
        
        //formulario para preguntar sobre siguiente estado
        this.crearFormEstados(); 
        //formulario para crear nuevos procesos
        this.crearFormInitProceso();     
      
        //formulario de asignacion de usuarios
        this.crearFormAsigUsu();
      
        this.bloquearOrdenamientoGrid();
        
        //evento del combo depto
        this.sw_init = true
        this.cmbDeptoAdq.on('select',function(){
             this.desbloquearOrdenamientoGrid();
             this.store.baseParams.id_depto =this.cmbDeptoAdq.getValue();
             if(this.sw_init){
                  
                  this.store.load({params:{start:0, limit:this.tam_pag}}); 
                  this.sw_init = true;
              }
             else{
                  this.store.reload();
                  
             }
         },this);
        
        this.store.baseParams={tipo_interfaz:this.nombreVista,tipo_interfaz:'aprobadores',filtro_aprobadas:1,filtro_solo_aprobadas:1};
       
	},
	
	
	
	cmbDeptoAdq:new Ext.form.ComboRec({
                name:'id_depto',
                hiddenName: 'id_depto',
                origen:'DEPTO',
                allowBlank:false,
                fieldLabel: 'Depto',
                gdisplayField:'desc_depto',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
                width:180,
                gwidth:100,
                baseParams:{estado:'activo',codigo_subsistema:'ADQ',tipo_filtro:'DEPTO_UO'},//parametros adicionales que se le pasan al store
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
            }),
	
	   
    crearFormEstados:function(){
        
        this.formEstado = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
           
            border: false,
            layout: 'form',
             autoHeight: true,
           
    
            items: [
                {
                    xtype: 'combo',
                    name: 'id_tipo_estado',
                      hiddenName: 'id_tipo_estado',
                    fieldLabel: 'Siguiente Estado',
                    listWidth:280,
                    allowBlank: false,
                    emptyText:'Elija el estado siguiente',
                    store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_workflow/control/TipoEstado/listarTipoEstado',
                        id: 'id_tipo_estado',
                        root:'datos',
                        sortInfo:{
                            field:'tipes.codigo',
                            direction:'ASC'
                        },
                        totalProperty:'total',
                        fields: ['id_tipo_estado','codigo_estado','nombre_estado'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'tipes.nombre_estado#tipes.codigo'}
                    }),
                    valueField: 'id_tipo_estado',
                    displayField: 'codigo_estado',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    width:210,
                    gwidth:220,
                    minChars:2,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{codigo_estado}</p>Prioridad: <strong>{nombre_estado}</strong> </div></tpl>'
                
                },
                {
                    xtype: 'combo',
                    name: 'id_funcionario_wf',
                    hiddenName: 'id_funcionario_wf',
                    fieldLabel: 'Funcionario Resp.',
                    allowBlank: false,
                    emptyText:'Elija un funcionario',
                    listWidth:280,
                    store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_workflow/control/TipoEstado/listarFuncionarioWf',
                        id: 'id_funcionario',
                        root:'datos',
                        sortInfo:{
                            field:'prioridad',
                            direction:'ASC'
                        },
                        totalProperty:'total',
                        fields: ['id_funcionario','desc_funcionario','prioridad'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'fun.desc_funcionario1'}
                    }),
                    valueField: 'id_funcionario',
                    displayField: 'desc_funcionario',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    width:210,
                    gwidth:220,
                    minChars:2,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_funcionario}</p>Prioridad: <strong>{prioridad}</strong> </div></tpl>'
                
                },
                    {
                        name: 'obs',
                        xtype: 'textarea',
                        fieldLabel: 'Intrucciones',
                        allowBlank: false,
                        anchor: '80%',
                        maxLength:500
                    },
                  {
                    xtype: 'combo',
                    name:'instruc_rpc',
                    fieldLabel:'Proceder',
                    allowBlank:false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    valueField: 'estilo',
                    gwidth: 100,
                    store:['Iniciar Contrato','Orden de Bien/Servicio','Cotizar','Solicitar Pago']
                }]
        });
        
        
         this.wEstado = new Ext.Window({
            title: 'Estados',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 380,
            height: 290,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formEstado,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.confSigEstado,
                scope:this
                
            },
             {
                    text: 'Guardar',
                    handler:this.antEstadoSubmmit,
                    scope:this
                    
             },
             {
                text: 'Cancelar',
                handler:function(){this.wEstado.hide()},
                scope:this
            }]
        });
        
        this.cmbTipoEstado =this.formEstado.getForm().findField('id_tipo_estado');
        this.cmbTipoEstado.store.on('loadexception', this.conexionFailure,this);
        this.cmbFuncionarioWf =this.formEstado.getForm().findField('id_funcionario_wf');
        this.cmbFuncionarioWf.store.on('loadexception', this.conexionFailure,this);
      
        this.cmpObs=this.formEstado.getForm().findField('obs');
        
        this.cmbIntrucRPC =this.formEstado.getForm().findField('instruc_rpc');
       
        
        this.cmbTipoEstado.on('select',function(){
            
            this.cmbFuncionarioWf.enable();
            this.cmbFuncionarioWf.store.baseParams.id_tipo_estado = this.cmbTipoEstado.getValue();
            this.cmbFuncionarioWf.modificado=true;
            
            this.cmbFuncionarioWf.store.load({params:{start:0,limit:this.tam_pag}, 
                       callback : function (r) {
                           if (r.length >= 1 ) {                       
                                this.cmbFuncionarioWf.setValue(r[0].data.id_funcionario);
                                this.cmbFuncionarioWf.fireEvent('select', r[0]);
                            }    
                                            
                        }, scope : this
                    });
            
        },this);
        
        
        
    },
    
        
    crearFormInitProceso:function(){
        
        this.formProceso = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
           
            border: false,
            layout: 'form',
            autoHeight: true,
           
    
            items: [
                   {
                     xtype: 'textfield',
                     labelSeparator:'',
                     inputType:'hidden',
                     name: 'id_solicitud',  
                   },
                   {
                     xtype: 'textfield',
                     labelSeparator:'',
                     inputType:'hidden',
                     name: 'id_depto',  
                   },
                   {
                     xtype: 'textfield',
                     labelSeparator:'',
                     inputType:'hidden',
                     name: 'id_proceso_copra',  
                   },
                   {
                    xtype: 'combo',
                    name: 'id_depto_usuario',
                    hiddenName: 'id_depto_usuario',
                    fieldLabel: 'Auxiliar',
                    listWidth:280,
                    allowBlank: false,
                    store:new Ext.data.JsonStore(
                    {
                        url:    '../../sis_parametros/control/DeptoUsuario/listarDeptoUsuario',
                        id: 'id_depto_usuario',
                        root:'datos',
                        sortInfo:{
                            field:'id_depto_usuario',
                            direction:'ASC'
                        },
                        totalProperty:'total',
                        fields: ['id_depto_usuario','id_usuario','desc_usuario','cargo'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'person.nombre_completo1'}
                    }),
                    valueField: 'id_depto_usuario',
                    displayField: 'desc_usuario',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    width:210,
                    gwidth:220,
                    minChars:2,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_usuario}</p>Tarea: <strong>{cargo}</strong> </div></tpl>'
                
                    },
                
                
                    {
                        xtype: 'textfield',
                        name: 'num_tramite',
                        fieldLabel: 'N# Tramite',
                        readOnly:true,
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 130,
                        maxLength:200
                    },
                    {
                        xtype: 'textarea',
                        name: 'instruc_rpc',
                        fieldLabel: 'Ins/RPC',
                        readOnly:true,
                        allowBlank: true,
                        anchor: '90%',
                        //width: 350,
                        height:100,
                        maxLength:2000
                    },
                    {
                        xtype: 'textfield',
                        name: 'codigo_proceso',
                        fieldLabel: 'Código Proceso',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:50
                    },
                    {
                        xtype: 'datefield',
                        name: 'fecha_ini_proc',
                        fieldLabel: 'Fecha Inicio',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',   
                        value: new Date()
                        
                    },
                    {
                        xtype: 'textarea',
                        name: 'obs_proceso',
                        fieldLabel: 'Observaciones',
                        allowBlank: true,
                        anchor: '90%',
                        width: 350,
                        maxLength:500   
                        
                    },
					 {
                        xtype: 'textarea',
                        name: 'objeto',
                        fieldLabel: 'Objeto',
                        allowBlank: true,
                        anchor: '90%',
                        width: 350,
                        maxLength:500   
                        
                    }
                    
                    ]
        });
        
        
         this.winProc = new Ext.Window({
            title: 'Nuevo Proceso',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 430,
            height: 350,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formProceso,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.guardarProceso,
                scope:this
                
            },
             {
                text: 'Cancelar',
                handler:function(){this.winProc.hide()},
                scope:this
            }]
        });
        
        this.cmbNumTramite =this.formProceso.getForm().findField('num_tramite');
        this.cmbIdSolicitud =this.formProceso.getForm().findField('id_solicitud');
        this.cmbIdDepto =this.formProceso.getForm().findField('id_depto');
       
        this.cmbInstrucRPC =this.formProceso.getForm().findField('instruc_rpc');
        this.cmbFechaProc =this.formProceso.getForm().findField('fecha_ini_proc');
        
        this.cmb_id_depto_usuario_proc = this.formProceso.getForm().findField('id_depto_usuario');
       
        
         
        
    },
    
    
    crearFormAsigUsu:function(){
        
        this.formAsigUsuario = new Ext.form.FormPanel({
            baseCls: 'x-plain',
            autoDestroy: true,
           
            border: false,
            layout: 'form',
            autoHeight: true,
           
    
            items: [
                   {
                     xtype: 'textfield',
                     labelSeparator:'',
                     inputType:'hidden',
                     name: 'id_solicitud',  
                   },
                   {
                    xtype: 'combo',
                    name: 'id_depto_usuario',
                    hiddenName: 'id_depto_usuario',
                    fieldLabel: 'Auxiliar',
                    listWidth:280,
                    allowBlank: false,
                    store:new Ext.data.JsonStore(
                    {
                        url:    '../../sis_parametros/control/DeptoUsuario/listarDeptoUsuario',
                        id: 'id_depto_usuario',
                        root:'datos',
                        sortInfo:{
                            field:'id_depto_usuario',
                            direction:'ASC'
                        },
                        totalProperty:'total',
                        fields: ['id_depto_usuario','id_usuario','desc_usuario','cargo'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'person.nombre_completo1'}
                    }),
                    valueField: 'id_depto_usuario',
                    displayField: 'desc_usuario',
                    forceSelection:true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:50,
                    queryDelay:500,
                    width:210,
                    gwidth:220,
                    minChars:2,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p>{desc_usuario}</p>Tarea: <strong>{cargo}</strong> </div></tpl>'
                
                }
                ]
        });
        
        
         this.winAsigUsu = new Ext.Window({
            title: 'Asignar Usuario al Proceso',
            collapsible: true,
            maximizable: true,
             autoDestroy: true,
            width: 430,
            height: 150,
            layout: 'fit',
            plain: true,
            bodyStyle: 'padding:5px;',
            buttonAlign: 'center',
            items: this.formAsigUsuario,
            modal:true,
             closeAction: 'hide',
            buttons: [{
                text: 'Guardar',
                 handler:this.guardarAsigUsu,
                scope:this
                
            },
             {
                text: 'Cancelar',
                handler:function(){this.winAsigUsu.hide()},
                scope:this
            }]
        });
        
        this.cmb_id_depto_usuario = this.formAsigUsuario.getForm().findField('id_depto_usuario');
        this.cmb_id_solicitud = this.formAsigUsuario.getForm().findField('id_solicitud');
       
        
         
        
    },
    
    
    initProceso:function(){
       
        var d= this.sm.getSelected().data;
        if(d){
            this.formProceso.getForm().reset();
            this.cmbNumTramite.setValue(d.num_tramite);
            this.cmbIdSolicitud.setValue(d.id_solicitud);
            this.cmbIdDepto.setValue(this.cmbDeptoAdq.getValue());
            this.cmbInstrucRPC.setValue(d.obs+' \n----- \n Intr:'+d.instruc_rpc)
            this.winProc.show(); 
            this.cmb_id_depto_usuario_proc.store.baseParams.id_depto = d.id_depto;
            this.cmb_id_depto_usuario_proc.modificado = true;
            this.cmbFechaProc.setValue(new Date());
            
            
        }
         
        
    },
    
    initAsigUsu:function(){
       
       
        var d= this.sm.getSelected().data;
        if(d){
            
            this.cmb_id_depto_usuario.store.baseParams.id_depto = d.id_depto;
            this.cmb_id_depto_usuario.modificado = true
            this.cmb_id_solicitud.setValue(d.id_solicitud);
            this.winAsigUsu.show(); 
        }
         
        
    },
    
    
	confSigEstado :function() {                   
            var d= this.sm.getSelected().data;
           
            if (this.formEstado .getForm().isValid()){
                 Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        // form:this.form.getForm().getEl(),
                        url:'../../sis_adquisiciones/control/Solicitud/siguienteEstadoSolicitud',
                        params:{
                            id_solicitud:d.id_solicitud,
                            operacion:'cambiar',
                            id_tipo_estado:this.cmbTipoEstado.getValue(),
                            id_funcionario:this.cmbFuncionarioWf.getValue(),
                            obs:this.cmpObs.getValue(),
                            instruc_rpc:this.cmbIntrucRPC.getValue()
                            },
                        success:this.successSinc,
                        failure: this.conexionFailure,
                        timeout:this.timeout,
                        scope:this
                    }); 
              }    
        }, 
        
        
    /*Registra nuevos procesos*/    
    guardarProceso :function() {                   
            var d= this.sm.getSelected().data;
            
            if (this.formProceso.getForm().isValid()){
                 Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        // form:this.form.getForm().getEl(),
                        url:'../../sis_adquisiciones/control/ProcesoCompra/insertarProcesoCompra',
                        params:this.formProceso.getForm().getValues(),
                        success:this.successSinc,
                        failure: this.conexionFailure,
                        timeout:this.timeout,
                        scope:this
                    }); 
            }
            
                
        }, 
     
      /*asgina usuario a los procesos de la solcitud*/    
    guardarAsigUsu :function() {                   
            var d= this.sm.getSelected().data;
            if (this.formAsigUsuario.getForm().isValid()){
                 Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        url:'../../sis_adquisiciones/control/ProcesoCompra/asignarUsuarioProceso',
                        params:this.formAsigUsuario.getForm().getValues(),
                        success:this.successSinc,
                        failure: this.conexionFailure,
                        timeout:this.timeout,
                        scope:this
                    }); 
            }
            
                
        },       
  
  
  
    validarFiltros:function(){
        if(this.cmbDeptoAdq.isValid()){
            return true;
        }
        else{
            return false;
        }
        
    },
    onButtonAct:function(){
        if(!this.validarFiltros()){
            alert('Especifique los filtros antes')
         }
        else{
            this.store.baseParams.id_depto=this.cmbDeptoAdq.getValue();
            Phx.vista.SolicitudApro.superclass.onButtonAct.call(this);
        }
    },   
    
    sigEstado:function(){                   
            var d= this.sm.getSelected().data;
           
            Phx.CP.loadingShow();
            this.cmbTipoEstado.reset();
            this.cmbFuncionarioWf.reset();
            this.cmbFuncionarioWf.store.baseParams.id_estado_wf=d.id_estado_wf;
            this.cmbFuncionarioWf.store.baseParams.fecha=d.fecha_soli;
            
            this.cmbTipoEstado.show();
            this.cmbFuncionarioWf.show();
            this.cmbTipoEstado.enable();
         
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Solicitud/siguienteEstadoSolicitud',
                params:{id_solicitud:d.id_solicitud,
                        operacion:'verificar',
                        obs:this.cmpObs.getValue()},
                success:this.successSinc,
                argument:{data:d},
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });     
        },
       
      antEstado:function(res,eve) {                   
            this.wEstado.buttons[0].hide();
            this.wEstado.buttons[1].show();
            this.wEstado.show();
            
            this.cmbTipoEstado.hide();
            this.cmbFuncionarioWf.hide();
            this.cmbTipoEstado.disable();
            this.cmbFuncionarioWf.disable();
            this.cmbIntrucRPC.hide();
            this.cmbIntrucRPC.disable(); 
            this.cmpObs.setValue('');
            
            this.sw_estado =res.argument.estado;
           
               
        },
        
        antEstadoSubmmit:function(res){
            var d= this.sm.getSelected().data;
           
            Phx.CP.loadingShow();
            var operacion = 'cambiar';
            operacion=  this.sw_estado == 'inicio'?'inicio':operacion; 
            
            Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_adquisiciones/control/Solicitud/anteriorEstadoSolicitud',
                params:{id_solicitud:d.id_solicitud, 
                        id_estado_wf:d.id_estado_wf, 
                        operacion: operacion,
                        obs:this.cmpObs.getValue()},
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
                  this.wEstado.hide();
                  this.winProc.hide();
                  this.winAsigUsu.hide()
                  
                  this.formAsigUsuario.getForm().reset();
             }
            else{
                
                alert('ocurrio un error durante el proceso')
            }
           
            
        },
     
  preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
      Phx.vista.SolicitudApro.superclass.preparaMenu.call(this,n);  
          
        if(data.estado =='aprobado' ){ 
            this.getBoton('ant_estado').enable();
            this.getBoton('ini_proc').enable();
            this.getBoton('ini_estado').enable();
            this.getBoton('asig_usu').disable();
        }
        if(data.estado =='proceso'){
            this.getBoton('ant_estado').disable();
            this.getBoton('ini_proc').disable();
            this.getBoton('ini_estado').disable();
            this.getBoton('asig_usu').enable();
            
            
        }
        
        if(data.estado !='aprobado' && data.estado !='proceso' ){
            this.getBoton('ant_estado').disable();
            this.getBoton('ini_proc').disable();
            this.getBoton('ini_estado').disable();
            this.getBoton('asig_usu').disable();
        }
       
       //habilitar reporte de colicitud de comrpa y preorden de compra
      this.menuAdq.enable(); 
       
        return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.SolicitudApro.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('ini_proc').disable();
            this.getBoton('ini_estado').disable();
            this.getBoton('ant_estado').disable();
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
