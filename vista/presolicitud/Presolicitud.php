<?php
/**
*@package pXP
*@file gen-Presolicitud.php
*@author  (admin)
*@date 10-05-2013 05:03:41
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * 	ISSUE		FECHA:	         AUTOR:				 DESCRIPCION:	
 * #4 endeETR  	19/02/2019       EGS                 se implemento el flujo WF en el proceso con sus funciones
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Presolicitud=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Presolicitud.superclass.constructor.call(this,config);
		  
		this.init();
		
		this.addButton('btnReporte',{
            text :'',
            iconCls : 'bpdf32',
            disabled: true,
            handler : this.onButtonPresolicitud,
            tooltip : '<b>Reporte Presolicitud de Compra</b><br/><b>Reporte Presolicitud de Compra</b>'
  });
  
		this.addButton('ant_estado',{argument: {estado: 'anterior'},text:'Anterior',iconCls: 'batras',disabled:true,handler:this.anteriorEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
		this.addBotonesGantt();// #4 EGS
	},
	addBotonesGantt: function() {// #4 EGS
	        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
	            id: 'b-diagrama_gantt-' + this.idContenedor,
	            text: 'Gantt',
	            disabled: true,
	            grupo:[0,1,2,3],
	            iconCls : 'bgantt',
	            handler:this.diagramGanttDinamico,
	            scope: this,
	            menu:{
		            items: [{
		                id:'b-gantti-' + this.idContenedor,
		                text: 'Gantt Imagen',
		                tooltip: '<b>Muestra un reporte gantt en formato de imagen</b>',
		                handler:this.diagramGantt,
		                scope: this
		            }, {
		                id:'b-ganttd-' + this.idContenedor,
		                text: 'Gantt Dinámico',
		                tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
		                handler:this.diagramGanttDinamico,
		                scope: this
		            }]
	            }
	        });
			this.tbar.add(this.menuAdqGantt);
   		},
	diagramGantt: function (){	// #4 EGS		
		var data=this.sm.getSelected().data.id_proceso_wf;

		Phx.CP.loadingShow();
		Ext.Ajax.request({
			url:'../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
			params:{'id_proceso_wf':data},
			success: this.successExport,
			failure: this.conexionFailure,
			timeout: this.timeout,
			scope: this
		});			
	},
	
	diagramGanttDinamico: function (){	// #4 EGS		
		var data=this.sm.getSelected().data.id_proceso_wf;

		window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+data)		
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_presolicitud'
			},
			type:'Field',
			form:true 
		},
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_gestion'
            },
            type:'Field',
            form:true 
        },		
        {
			config:{// #4 EGS
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_proceso_wf'
			},
			type:'Field',
			form:true
		},
		{
			config:{// #4 EGS
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_estado_wf'
			},
			type:'Field',
			form:true
		},
		{
			config:{// #4 EGS
				name: 'nro_tramite',
				fieldLabel: 'Nro. Tramite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:20
			},
			type:'TextField',
			filters:{pfiltro:'fase.estado',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
        {
            config:{
                name: 'estado',
                fieldLabel: 'estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:30
            },
            type:'TextField',
            filters:{pfiltro:'pres.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
       
        {
            config:{
                name:'id_depto',
                 hiddenName: 'id_depto',
                 url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
                    origen:'DEPTO',
                    allowBlank:false,
                    fieldLabel: 'Depto',
                    gdisplayField:'desc_depto',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
                    width:250,
                    gwidth:180,
                    baseParams:{estado:'activo',codigo_subsistema:'ADQ'},//parametros adicionales que se le pasan al store
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
            },
            //type:'TrigguerCombo',
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'d.nombre#d.codigo',type:'string'},
            grid:true,
            form:true
        },
        {
            config:{
                name:'id_grupo',
                fieldLabel:'Grupo de Compras',
                allowBlank:false,
                emptyText:'Grupo...',
                store: new Ext.data.JsonStore({

                    url: '../../sis_adquisiciones/control/Grupo/listarGrupo',
                    id: 'id_grupo',
                    root: 'datos',
                    sortInfo:{
                        field: 'id_grupo',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_grupo','nombre','obs'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'nombre#obs'}
                }),
                valueField: 'id_grupo',
                displayField: 'nombre',
                gdisplayField:'desc_grupo',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p><p>CI:{obs}</p> </div></tpl>',
                hiddenName: 'id_grupo',
                forceSelection:true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                width:250,
                gwidth:280,
                minChars:2,
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_grupo']);}
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'gru.nombre#gru.obs',
                        type:'string'
                    },
           
            grid:true,
            form:true
        },
		         
        {
            config:{
                name: 'fecha_soli',
                fieldLabel: 'Fecha Sol.',
                allowBlank: false,
                disabled: true,
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'pres.fecha_soli',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
        },
         {
            config:{
                name:'id_funcionario',
                 hiddenName: 'id_funcionario',
                origen:'FUNCIONARIOCAR',
                fieldLabel:'Funcionario',
                allowBlank:false,
                gwidth:200,
                valueField: 'id_funcionario',
                gdisplayField: 'desc_funcionario',
                baseParams: { es_combo_solicitud : 'si' },
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
             },
            type:'ComboRec',//ComboRec
            id_grupo:0,
            filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
            grid:true,
            form:true
         },
           {
            config:{
                name:'id_uo',
                hiddenName: 'id_uo',
                origen:'UO',
                fieldLabel:'UO',
                gdisplayField:'desc_uo',//mapea al store del grid
                 disabled:true,
                gwidth:200,
                 renderer:function (value, p, record){return String.format('{0}', record.data['desc_uo']);}
             },
             type:'ComboRec',
             id_grupo:1,
             filters:{   
                pfiltro:'uo.codigo#uo.nombre_unidad',
                type:'string'
             },
             grid:true,
             form:true
           },
          
         {
            config:{
                name:'id_funcionario_supervisor',
                hiddenName: 'id_funcionario_supervisor',
                origen:'FUNCIONARIOCAR',
                fieldLabel:'Supervisor',
                allowBlank:false,
                disabled:true,
                gwidth:200,
                valueField: 'id_funcionario',
                gdisplayField: 'desc_funcionario_apro',
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario_supervisor']);}
             },
            type:'ComboRec',//ComboRec
            filters:{pfiltro:'funs.desc_funcionario1',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
         },
		{
			config:{
				name: 'obs',
				fieldLabel: 'obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'pres.obs',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
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
			filters:{pfiltro:'pres.fecha_reg',type:'date'},
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
            filters:{pfiltro:'pres.estado_reg',type:'string'},
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
			filters:{pfiltro:'usu1.cuenta',type:'string'},
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
			filters:{pfiltro:'pres.fecha_mod',type:'date'},
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
			type:'NumberField',
			filters:{pfiltro:'usu2.cuenta',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Presolicitud',
	ActSave:'../../sis_adquisiciones/control/Presolicitud/insertarPresolicitud',
	ActDel:'../../sis_adquisiciones/control/Presolicitud/eliminarPresolicitud',
	ActList:'../../sis_adquisiciones/control/Presolicitud/listarPresolicitud',
	id_store:'id_presolicitud',
	fields: [
		{name:'id_presolicitud', type: 'numeric'},
		{name:'id_grupo', type: 'numeric'},
		{name:'id_funcionario_supervisor', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'obs', type: 'string'},
		{name:'id_uo', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'id_solicitudes', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_soli', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'desc_funcionario_supervisor',
		'desc_funcionario',
		'desc_uo',
		'desc_grupo','id_partidas',
		'id_depto','desc_depto','id_gestion',
		
						
		{name:'id_proceso_wf', type: 'numeric'},// #4 EGS
		{name:'id_estado_wf', type: 'numeric'},// #4 EGS
		{name:'nro_tramite', type: 'string'},// #4 EGS

		
	],


	
	onButtonPresolicitud:function(){
	    var rec=this.sm.getSelected();
                console.debug(rec);
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Presolicitud/reportePresolicitud',
                    params:{'id_presolicitud':rec.data.id_presolicitud,'estado':rec.data.estado},
                    success: this.successExport,
                    failure: function() {
                        console.log("fail");
                    },
                    timeout: function() {
                        console.log("timeout");
                    },
                    scope:this
                });  
	},

	sortInfo:{
		field: 'id_presolicitud',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false,
	////funciones para estados wf 
	   siguienteEstado: function(res){// #4 EGS
	    	if (this.nombreVista =='PresolicitudCon') 
			{
				var opcion = confirm('Seguro que quiere Finalizar la Presolicitud.Los Items consolidados en el detalle no podran ser eliminados ni modificados en la solicitud');
				if (opcion == true) {
					this.sigEstado(res);
				};
			} 
   		},
	  sigEstado:function(){                   
      var data = this.getSelectedData();
      console.log('data',data)     
      this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                                'Estado de Wf',
                                {
                                    modal:true,
                                    width:700,
                                    height:450
                                }, {data:{
                                	   id_presolicitud:data.id_presolicitud,
                                       id_estado_wf:data.id_estado_wf,
                                       id_proceso_wf:data.id_proceso_wf,
                                    	
                                    }}, this.idContenedor,'FormEstadoWf',
                                {
                                    config:[{
                                              event:'beforesave',
                                              delegate: this.onSaveWizard,
                                              
                                            }],
                                    
                                    scope:this
                                 });        
               
     },
      onSaveWizard:function(wizard,resp){// #4 EGS
        //console.log(wizard);
        //Phx.CP.loadingShow();
        Ext.Ajax.request({
            //url:'../../sis_workflow/control/ProcesoWf/siguienteEstadoProcesoWf',
            url:'../../sis_adquisiciones/control/Presolicitud/siguienteEstado',
            params:{
                id_presolicitud:      wizard.data.id_presolicitud,
                id_proceso_wf_act:  resp.id_proceso_wf_act,
                id_estado_wf_act:   resp.id_estado_wf_act,
                id_tipo_estado:     resp.id_tipo_estado,
                id_funcionario_wf:  resp.id_funcionario_wf,
                id_depto_wf:        resp.id_depto_wf,
                obs:                resp.obs,
                json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
            success:this.successWizard,
            failure: this.conexionFailure,
            argument:{wizard:wizard},
            timeout:this.timeout,
            scope:this
        });
         
    },
       successWizard:function(resp){// #4 EGS
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
        this.reload();
    },
    anteriorEstado: function(res){// #4 EGS
    	var data = this.getSelectedData();
    	if (this.nombreVista =='PresolicitudCon' && data.estado == 'asignado') 
		{
			var opcion = confirm('Seguro que quiere volver atras.Si tiene Items consolidados en el detalle estos se desconsolidaran');
			if (opcion == true) {
				this.antEstado(res);
			};
		} else{
				this.antEstado(res);
    	}
   },
    antEstado: function(res){// #4 EGS
		var data = this.getSelectedData();
			//obsValorInicial;	
		
		Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
			'Estado de Wf',
			{   modal: true,
			    width: 450,
			    height: 250
			}, 
			{    data: data, 
				 estado_destino: res.argument.estado
			    // obsValorInicial: obsValorInicial 
			}, 
			this.idContenedor,'AntFormEstadoWf',
			{
			    config:[{
			              event:'beforesave',
			              delegate: this.onAntEstado,
			            }],
			   scope:this
			});
		
	}, 
	onAntEstado: function(wizard,resp){// #4 EGS
        Phx.CP.loadingShow();
        var operacion = 'cambiar';

        Ext.Ajax.request({
              //url:'../../sis_workflow/control/ProcesoWf/anteriorEstadoProcesoWf',
                url:'../../sis_adquisiciones/control/Presolicitud/anteriorEstado',
            params:{
            	id_presolicitud: wizard.data.id_presolicitud,
                id_proceso_wf: resp.id_proceso_wf,
                id_estado_wf:  resp.id_estado_wf,  
                obs: resp.obs,
                operacion: operacion
             },
            argument:{wizard:wizard},  
            success: this.successAntEstado,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    }, 
    
       successAntEstado:function(resp){// #4 EGS
        Phx.CP.loadingHide();
        resp.argument.wizard.panel.destroy()
       this.reload();
       if (this.nombreVista =='PresolicitudCon') 
		{
       		Phx.CP.getPagina(this.idContenedorPadre).actualizarSolicitudDet(); 
      	}
    },  
	
	
   }
)
</script>
		
		