<?php
/**
*@package pXP
*@file gen-ProcesoCompra.php
*@author  (admin)
*@date 19-03-2013 12:55:30
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.ProcesoCompra=Ext.extend(Phx.gridInterfaz,{
    gruposBarraTareas:[{name:'pendientes',title:'<H1 align="center"><i class="fa fa-thumbs-o-down"></i> Pendientes</h1>',grupo:0,height:0},
                       {name:'iniciados',title:'<H1 align="center"><i class="fa fa-eye"></i> Iniciados</h1>',grupo:1,height:0},
                       {name:'contrato',title:'<H1 align="center"><i class="fa fa-file-o"></i> Para Contrato</h1>',grupo:2,height:0},
                       
                       {name:'en pago',title:'<H1 align="center"><i class="fa fa-credit-card"></i> En Pago</h1>',grupo:3,height:0},
                       
                       {name:'anulados',title:'<H1 align="center"><i class="fa fa-bell-o"></i> Anulados</h1>',grupo:4,height:0},
                       {name:'finalizados',title:'<H1 align="center"><i class="fa fa-thumbs-o-up"></i> Finalizados</h1>',grupo:5,height:0}],
	
    beditGroups: [0,1,2,3,4],
    bdelGroups:  [0,1,2,3,4],
    bactGroups:  [0,1,2,3,4,5],
    btestGroups: [0],
    bexcelGroups: [0,1,2,3,4,5],
    
    actualizarSegunTab: function(name, indice){
    	if(this.finCons){
    		 this.store.baseParams.estado = name;
    	     this.load({params:{start:0, limit:this.tam_pag}});
         }
    },
    
    stateId:'ProcesoCompra',
	
	constructor:function(config){
		
		this.maestro=config.maestro;
		
		//llama al constructor de la clase padre
		Phx.vista.ProcesoCompra.superclass.constructor.call(this,config);
		this.init();
		this.addButton('btnReporte',{
            text :'SC',
            iconCls : 'bpdf32',
            disabled: true,
            handler : this.onButtonSolicitud,
            tooltip : '<b> Solicitud</b><br/><b>Reporte de Solicitud de Compra</b>'
        });
        
		this.addButton('btnCotizacion',{grupo:[0,1,2,3,4], text :'Cotizacion',iconCls:'bdocuments',disabled: true, handler : this.onButtonCotizacion,tooltip : '<b>Cotizacion de solicitud de Compra</b><br/><b>Cotizacion de solicitud de Compra</b>'});
  		this.addButton('btnChequeoDocumentos',{grupo:[0,1,2,3,4], text: 'Documentos',iconCls: 'bchecklist',disabled: true,handler: this.loadCheckDocumentosSol,tooltip: '<b>Documentos del Proceso</b><br/>Subir los documetos requeridos en el proceso seleccionada.'});
        this.addButton('btnCuadroComparativo',{grupo:[0,1,2,3,4], text :'Cuadro Comparativo',iconCls : 'bexcel',disabled: true,handler : this.onCuadroComparativo,tooltip : '<b>Cuadro Comparativo</b><br/><b>Cuadro Comparativo de Cotizaciones</b>'});
	    this.addButton('chkpresupuesto',   {
	     	    grupo:[0,1,2,3,4],               
                text: 'Presup',
                iconCls: 'blist',
                tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para este  tramite</p>',
                handler:this.checkPresupuesto,               
                scope: this
            });
	    
	    
	    this.addButton('btnRevePres',{grupo:[0,1,2,3,4], text:'Rev. Pre.',iconCls: 'balert',disabled:true,handler:this.onBtnRevPres,tooltip: '<b>Revertir Presupuesto</b> Revierte todo el presupuesto no adjudicado para la solicitud.'});
        this.addButton('btnFinPro',{grupo:[0,1,2,3,4], text:'Fin Proc.',iconCls: 'balert',disabled:true,handler:this.onBtnFinPro,tooltip: '<b>Finzalizar Proceso</b> Finaliza el proceso y la solicitud y revierte el presupuesto. No  puede deshacerse'});
        this.addButton('diagrama_gantt',{grupo:[0,1,2,3,4,5], text:'Diagrama Gantt',iconCls: 'bgantt',disabled:true,handler:this.diagramGantt,tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
        
        this.store.baseParams={};
        //coloca filtros para acceso directo si existen
        if(config.filtro_directo){
           this.store.baseParams.filtro_valor = config.filtro_directo.valor;
           this.store.baseParams.filtro_campo = config.filtro_directo.campo;
        }
        this.store.baseParams.estado = 'pendientes'
        this.load({params:{start:0, limit:this.tam_pag}});
	    this.iniciarEventos();
	    this.finCons = true;
	
	},
	
	checkPresupuesto:function(){                   
			  var rec=this.sm.getSelected();
			  var configExtra = [];
			  this.objChkPres = Phx.CP.loadWindows('../../../sis_presupuestos/vista/presup_partida/ChkPresupuesto.php',
										'Estado del Presupuesto',
										{
											modal:true,
											width:700,
											height:450
										}, {
											data:{
											   nro_tramite: rec.data.num_tramite								  
											}}, this.idContenedor,'ChkPresupuesto');
			   
	 },
	
	diagramGantt:function(){  
		
		//window.open("../../../sis_workflow/vista/gantt/LineaTiempo.php");         
            /*
           var data = this.sm.getSelected().data.id_proceso_wf;
           var rec = this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_workflow/vista/gantt/gannt.php',
                    'Diagrama Gannt',
                    {
                        width:'98%',
                        height:'98%',
                        bodyStyle:{"background-color":"white"},
                    },
                    rec.data,
                    this.idContenedor,
                    'DinamicGannt');*/
                    
                    
          /* Phx.CP.openEmptyWindows('../../../sis_workflow/vista/gannt/repo.html',
                    'Diagrama Gannt',
                    {
                        width:'98%',
                        height:'98%'
                    },
                    { 'id_proceso_wf' : data },
                    this.idContenedor);*/
           

           
           //original ...
           

            Phx.CP.loadingShow();
            var data = this.sm.getSelected().data.id_proceso_wf;
            Ext.Ajax.request({
                url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                params:{'id_proceso_wf':data},
                success:this.successExport,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });  
            
       
            
                   
    },
    
    onButtonSolicitud:function(){
        var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_adquisiciones/control/Solicitud/reporteSolicitud',
            params:{'id_solicitud':rec.data.id_solicitud,'estado':rec.data.estado},
            success: this.successExport,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });  
    },
	
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proceso_compra',
					
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name: 'instruc_rpc',
                fieldLabel: 'Ins/RPC',
                allowBlank: true,
                anchor: '80%',
                gwidth: 140,
                maxLength:50
            },
            type:'Field',
            filters:{pfiltro:'instruc_rpc',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'num_tramite',
                fieldLabel: 'N# Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:200
            },
            type:'TextField',
            filters:{pfiltro:'num_tramite',type:'string'},
            bottom_filter: true,
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                renderer: function(value,p,record){
                        if(record.data.estado=='anulado'||record.data.estado=='desierto'){
                             return String.format('<b><font color="red">{0}</font></b>', value);
                         }
                         else if(record.data.estado=='finalizado'){
                             return String.format('<b><font color="green">{0}</font></b>', value);
                         }
                         else{
                            return String.format('{0}', value);
                        }},
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'estados_cotizacion',
                
                fieldLabel: 'Estados Cot',
                allowBlank: true,
                anchor: '80%',
                gwidth: 200,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'estados_cotizacion',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'numeros_oc',
                fieldLabel: 'Ordenes de Compra',
                allowBlank: true,
                anchor: '80%',
                gwidth: 200,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'numeros_oc',type:'string'},
            id_grupo:1,
            bottom_filter: true,
            grid:true,
            form:false
        },
        
        
		{
            config:{
                    name:'id_depto',
                    hiddenName: 'id_depto',
                    origen:'DEPTO',
                    allowBlank:false,
                    fieldLabel: 'Depto',
                    gdisplayField:'desc_depto',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
                    width:250,
                    gwidth:100,
                    baseParams:{estado:'activo',codigo_subsistema:'ADQ',tipo_filtro:'DEPTO_UO'},//parametros adicionales que se le pasan al store
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
            },
            //type:'TrigguerCombo',
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'desc_depto',type:'string'},
            grid:true,
            form:true
        },
        {
            config: {
                name: 'id_solicitud',
                hiddenName: 'id_solicitud',
                fieldLabel: 'Solicitud de Compra',
                typeAhead: false,
                forceSelection: false,
                allowBlank: false,
                emptyText: 'Solicitudes...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_adquisiciones/control/Solicitud/listarSolicitud',
                    id: 'id_solicitud',
                    root: 'datos',
                    sortInfo: {
                        field: 'numero',
                        direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_solicitud','numero','desc_uo','desc_funcionario','id_moneda','desc_moneda','desc_categoria_compra','num_tramite'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams: {par_filtro: 'sol.numero#fun.desc_funcionario1#uo.codigo#uo.nombre_unidad',tipo_interfaz:'aprobadores'}
                }),
                valueField: 'id_solicitud',
                displayField: 'numero',
                gdisplayField: 'desc_solicitud',
                gsortField:'sol.numero',
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 20,
                queryDelay: 200,
                listWidth:280,
                minChars: 2,
                gwidth: 170,
                renderer: function(value, p, record) {
                        if(record.data.estado=='anulado'||record.data.estado=='desierto'){
                             return String.format('<b><font color="red">{0}</font></b>', record.data['desc_solicitud']);
                         }
                         else if(record.data.estado=='finalizado'){
                             return String.format('<b><font color="green">{0}</font></b>', record.data['desc_solicitud']);
                         }
                         else{
                            return String.format('{0}', record.data['desc_solicitud']);
                        }
                },
                tpl: '<tpl for="."><div class="x-combo-list-item"><p>{numero}</p><p>Sol.: <strong>{desc_funcionario}</strong></p><p>UO: <strong>{desc_uo}</strong></p> </div></tpl>'
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {
                pfiltro: 'desc_solicitud',
                type: 'string'
            },
            grid: true,
            form: true
        },
        {
            config:{
                name: 'desc_funcionario',
                fieldLabel: 'Funcionario',
                allowBlank: true,
                anchor: '80%',
                gwidth: 200,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'desc_funcionario',type:'string'},
            bottom_filter: true,
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'proveedores_cot',
                fieldLabel: 'Proveedores',
                allowBlank: true,
                anchor: '80%',
                gwidth: 300,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'proveedores_cot',type:'string'},
            bottom_filter: true,
            id_grupo:1,
            grid:true,
            form:false
        },
        
        
        {
            config:{
                name: 'desc_moneda',
                
                fieldLabel: 'Moneda',
                allowBlank: true,
                anchor: '80%',
                gwidth: 50,
                maxLength:50
            },
            type:'TextField',
            filters:{pfiltro:'desc_moneda',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'usr_aux',
                fieldLabel: 'Aux',
                allowBlank: true,
                anchor: '80%',
                gwidth: 80,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'usr_aux',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'codigo_proceso',
                fieldLabel: 'Código Proceso',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:50
            },
            type:'TextField',
            filters:{pfiltro:'codigo_proceso',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        
        {
            config:{
                name: 'fecha_ini_proc',
                fieldLabel: 'Fecha Inicio',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'fecha_ini_proc',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'obs_proceso',
                fieldLabel: 'Observaciones',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:500
            },
            type:'TextArea',
            filters:{pfiltro:'obs_proceso',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'objeto',
                fieldLabel: 'Objeto',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:500
            },
            type:'TextArea',
            filters:{pfiltro:'objeto',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'num_cotizacion',
                fieldLabel: 'num_cotizacion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'num_cotizacion',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        }
        ,
		{
			config:{
				name: 'num_convocatoria',
				fieldLabel: 'Num Convocatoria',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
			type:'TextField',
			filters:{pfiltro:'num_convocatoria',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10
			},
			type:'TextField',
			filters:{pfiltro:'estado_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_reg',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'NumberField',
			filters:{pfiltro:'usr_reg',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_reg',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'usr_mod',
				fieldLabel: 'Modificado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
			type:'Field',
			filters:{pfiltro:'usr_mod',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Proceso de Compra',
	ActSave:'../../sis_adquisiciones/control/ProcesoCompra/insertarProcesoCompra',
	ActDel:'../../sis_adquisiciones/control/ProcesoCompra/eliminarProcesoCompra',
	ActList:'../../sis_adquisiciones/control/ProcesoCompra/listarProcesoCompra',
	id_store:'id_proceso_compra',
	fields: [
		{name:'id_proceso_compra', type: 'numeric'},
		{name:'id_depto', type: 'numeric'},
		{name:'num_convocatoria', type: 'string'},
		{name:'id_solicitud', type: 'numeric'},
		{name:'id_categoria_compra', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'fecha_ini_proc', type: 'date',dateFormat:'Y-m-d'},
		{name:'obs_proceso', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'num_tramite', type: 'string'},
		{name:'codigo_proceso', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'estado', type: 'string'},
		{name:'num_cotizacion', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'desc_moneda','desc_funcionario',
		'desc_uo','desc_depto','desc_solicitud','instruc_rpc',
		'usr_aux','id_moneda','id_funcionario','desc_cotizacion','objeto','estados_cotizacion','numeros_oc','proveedores_cot'
		
	],
	rowExpander: new Ext.ux.grid.RowExpander({
	        tpl : new Ext.Template(
	            '<br>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Departamento:&nbsp;&nbsp;</b> {desc_depto} , <b>Auxiliar</b>: {usr_aux}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Ordenes de compra:&nbsp;&nbsp;</b> {numeros_oc}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Estado proceso:&nbsp;&nbsp;</b> {estado}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Objeto:&nbsp;&nbsp;</b> {objeto}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Obs:&nbsp;&nbsp;</b> {obs_proceso}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Solicitud Nº:&nbsp;&nbsp;</b> {desc_solicitud}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Creado por:&nbsp;&nbsp;</b> {usr_reg}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Estado Registro:&nbsp;&nbsp;</b> {estado_reg}</p><br>'
	        )
    }),
    
    arrayDefaultColumHidden:['fecha_mod','usr_reg','usr_mod','estado','numeros_oc','id_depto','id_solicitud','usr_aux','codigo_proceso','fecha_ini_proc','obs_proceso','objeto','num_cotizacion','num_convocatoria','estado_reg','fecha_reg'],


	iniciarEventos:function(){
	  this.cmbDepto = this.getComponente('id_depto');
	  this.cmbSolicitud = this.getComponente('id_solicitud');
	  this.cmpNumTramite = this.getComponente('num_tramite');
	  this.cmbSolicitud.disable();
	  this.cmpNumTramite.disable();
	  
	  
	  this.cmbDepto.on('select',function(){
	      this.cmbSolicitud.enable();
	      this.cmbSolicitud.store.baseParams.id_depto =this.cmbDepto.getValue();
	      this.cmbSolicitud.store.baseParams.estado = 'aprobado';
	      this.cmbSolicitud.reset();
	      this.cmbSolicitud.modificado=true;
	  },this);
	  
	  this.cmbSolicitud.on('select',function(cmb,dat,c){
	      
            this.cmpNumTramite.setValue(dat.data.num_tramite)
      },this);
	  
	  
	  
	},
	loadCheckDocumentosSol:function() {
            var rec=this.sm.getSelected();
            
            var datos = { nombreVista: this.nombreVista,
            	          gruposBarraTareas: [
            	               {name:'proceso',title:"<H1 align=center><i class=\"fa fa-thumbs-o-down\"></i> del Proceso</h1>",grupo:0,height:0},
                               {name:'legales',title:"<H1 align=center><i class=\"fa fa-eye\"></i> Legales</h1>",grupo:1,height:0}]};
	
			
            Phx.CP.loadWindows(
            	     '../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Chequear documento del WF',
                    {
                        width:'90%',
                        height:500
                       
                    },
                    Ext.apply(datos, rec.data),
                    this.idContenedor,
                    'DocumentoWf');
    },
	
	onBtnRevPres:function(){
	    if(confirm('¿Está seguro de revertir el Presupuesto?. Esta acción no puede deshacerse')){
	      if(confirm('¿Está realmente seguro?')){
                var data=this.sm.getSelected().data;
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/ProcesoCompra/revertirPresupuesto',
                    params:{'id_proceso_compra':data.id_proceso_compra,'id_solicitud':data.id_solicitud},
                    success:this.successRevPre,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });
              
	        
	      }
	    }
	},
	
	onBtnFinPro:function(){
        if(confirm('¿Está seguro Finalizar el Proceso?. Esta acción no puede deshacerse')){
          if(confirm('¿Está realmente seguro?')){
                var data=this.sm.getSelected().data;
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/ProcesoCompra/finalizarProceso',
                    params:{'id_proceso_compra':data.id_proceso_compra,'id_solicitud':data.id_solicitud},
                    success:this.successRevPre,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });
           }
        }
    },
	
	successRevPre:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                this.reload();
            }else{
                alert('ocurrio un error durante el proceso')
            }
     },
	
	 onButtonCotizacion:function() {
            var rec=this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_adquisiciones/vista/cotizacion/CotizacionAdq.php',
                    'Cotizacion de solicitud de compra',
                    {
                        width:'98%',
                        height:'98%'
                    },
                    rec.data,
                    this.idContenedor,
                    'CotizacionAdq');
    },
    
	onCuadroComparativo: function(){
					var rec=this.sm.getSelected();
         console.debug(rec);
         Ext.Ajax.request({
             url:'../../sis_adquisiciones/control/ProcesoCompra/cuadroComparativo',
             params:{'id_proceso_compra':rec.data.id_proceso_compra},
             success: this.successExport,
             failure: function() {
                 alert("fail");
             },
             timeout: function() {
                 alert("timeout");
             },
             scope:this
         });
	   },
    
    onButtonNew:function(){         
            Phx.vista.ProcesoCompra.superclass.onButtonNew.call(this);
            this.cmbSolicitud.enable();
            this.cmbDepto.enable();          
    },
    onButtonEdit:function(){         
            Phx.vista.ProcesoCompra.superclass.onButtonEdit.call(this);
            this.cmbSolicitud.disable();  
            this.cmbDepto.disable();        
    },
    
    
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
        
        Phx.vista.ProcesoCompra.superclass.preparaMenu.call(this,n);
        this.getBoton('btnChequeoDocumentos').enable();
        this.getBoton('diagrama_gantt').enable();
        this.getBoton('chkpresupuesto').enable();
        
        
        if(data.estado=='anulado' || data.estado=='desierto'|| data.estado=='finalizado'){
            this.getBoton('edit').disable();
            this.getBoton('del').disable();
            this.getBoton('btnCotizacion').disable();
            this.getBoton('btnCuadroComparativo').disable();
            this.getBoton('btnRevePres').disable();
            this.getBoton('btnFinPro').disable();
            this.getBoton('btnReporte').disable();
            
            if(data.estado=='finalizado'){
                
                this.getBoton('btnCuadroComparativo').enable();
                this.getBoton('btnCotizacion').enable();
                this.getBoton('btnReporte').enable();
                
                
            }
             
            
        }
        else{
            this.getBoton('btnCotizacion').enable();
            this.getBoton('btnCuadroComparativo').enable();
            this.getBoton('btnRevePres').enable();
            this.getBoton('btnFinPro').enable();
            this.getBoton('btnReporte').enable();
           
        }
         return tb 
     },
     
     liberaMenu:function(){
        var tb = Phx.vista.ProcesoCompra.superclass.liberaMenu.call(this);
        if(tb){           
            this.getBoton('btnCotizacion').setDisabled(true);  
            this.getBoton('btnChequeoDocumentos').disable(); 
            this.getBoton('btnCuadroComparativo').disable();
            this.getBoton('diagrama_gantt').disable(); 
            this.getBoton('btnReporte').disable(); 
            this.getBoton('chkpresupuesto').disable();      
        }
       return tb
    },
    
	sortInfo:{
		field: 'fecha_reg',
		direction: 'DESC'
	},
	south:
          { 
          url:'../../../sis_adquisiciones/vista/solicitud_det/SolicitudVbDet.php',
          title:'Detalle', 
          height:'30%',
          cls:'SolicitudVbDet'
         },
	bdel:true,
	bsave:false,
	bnew:false
    
})
</script>