<?php
/**
*@package pXP
*@file gen-Solicitud.php
*@author  (admin)
*@date 19-02-2013 12:12:51
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * 
 * 
****************************************************************************
* ISSUE            FECHA:		      AUTOR       DESCRIPCION
* #10  ETR      21/02/2018          RAC         se incrementa columna para comproemter al 87 %
* #11 			19/09/2018			EGS			se habilito el campo observacion
* #4   endeEtr	05/02/2019			EGS			se recarga las presolicitudes cuando se elimina en la un detalle de solicitud asociado a una presolicitud
* #6 endeEtr	26/3/2019			EGS			Se habilita tipo llave en mano  
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Solicitud=Ext.extend(Phx.gridInterfaz,{   
	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre		
		Phx.vista.Solicitud.superclass.constructor.call(this,config);
		this.init();		
		this.addBotones(); 
		//
        
	
        /*
		this.addButton('btnReporte',{
            text :'',
            iconCls : 'bpdf32',
            disabled: true,
            handler : this.onButtonSolicitud,
            tooltip : '<b>Reporte Solicitud de Compra</b><br/><b>Reporte Solicitud de Compra</b>'
       }); */
  
        //this.addButton('diagrama_gantt',{ grupo:[0,1,2],text:'Gantt', iconCls: 'bgantt', disabled:true, handler: this.diagramGantt, tooltip: '<b>Diagrama Gantt de proceso macro</b>'});
  
	    this.addBotonesGantt();
        this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Documentos',
                grupo:[0,1,2],
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );
        
        this.addButton('btnObs',{
                    text :'Obs Wf',
                    grupo:[0,1,2],
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onOpenObs,
                    tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
         });


        this.addButton('btnDetalleGasto',
            {
                text: 'Subir Detalle Gasto',
                iconCls: 'bdocuments',
                disabled: true,
                handler: this.onDetalleGasto,
                tooltip: 'Subir archivo con el detalle de gasto'
            }
        );
        
         this.addButton('chkpresupuesto',   {
	     	    grupo:[0,1,2,3,4],               
                text: 'Presup',
                iconCls: 'blist',
                tooltip: '<b>Revisar Presupuesto</b><p>Revisar estado de ejecución presupeustaria para este  tramite</p>',
                handler:this.wndowsCheckPresupuesto,               
                scope: this
         });

		/*this.addButton('reporte_veri',{
			text:'Reporte Verificacion',
			iconCls: 'bdocuments',
			disabled:false,
			handler:this.reporte_veri,
			tooltip: '<b>Reporte</b>'
		});*/
	    
	},
	
	diagramGantt: function (){			
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
	diagramGanttDinamico: function (){			
			var data=this.sm.getSelected().data.id_proceso_wf;
			window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+data)		
	},  
	
	addBotones: function() {
        this.menuAdq = new Ext.Toolbar.SplitButton({
            id: 'btn-adqrep-' + this.idContenedor,
            text: 'Rep.',
            grupo:[0,1,2],
            disabled: true,
            iconCls : 'bpdf32',
            handler:this.onButtonSolicitud,
            scope: this,
            menu:{
            items: [{
                id:'b-btnSolicitud-' + this.idContenedor,
                text: 'Solicitud',
                tooltip: '<b>Reporte de Solicitud de Compra</b>',
                handler:this.onButtonSolicitud,               
                scope: this
            }, {
                id:'b-btnRepOC-' + this.idContenedor,
                text: 'Pre-orden de Compra',
                tooltip: '<b>Reporte de Pre-orden de Compra</b>',
                handler:this.onButtonRepOC,
                scope: this
            }
        ]}
        });
		this.tbar.add(this.menuAdq);
    },
    
    addBotonesGantt: function() {
        this.menuAdqGantt = new Ext.Toolbar.SplitButton({
            id: 'b-diagrama_gantt-' + this.idContenedor,
            text: 'Gantt',
            disabled: true,
            grupo:[0,1,2],
            iconCls : 'bgantt',
            handler:this.diagramGanttDinamico,
            scope: this,
            menu:{
            items: [{
                id:'b-gantti-' + this.idContenedor,
                text: 'Gantt Imagen',
                tooltip: '<b>Mues un reporte gantt en formato de imagen</b>',
                handler:this.diagramGantt,
                scope: this
            }, {
                id:'b-ganttd-' + this.idContenedor,
                text: 'Gantt Dinámico',
                tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
                handler:this.diagramGanttDinamico,
                scope: this
            }
        ]}
        });
		this.tbar.add(this.menuAdqGantt);
    },
	
	arrayStore :{
                    'Bien':[
                                ['bien','Bienes'],
                                //['inmueble','Inmuebles'],
                                //['vehiculo','Vehiculos']
                     ],	
                     'Servicio':[
                                ['servicio','Servicios'],
                                ['consultoria_personal','Consultoria de Personas'],
                                ['consultoria_empresa','Consultoria de Empresas'],
                                //['alquiler_inmueble','Alquiler Inmuebles']
                     ]
    },
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_solicitud'
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
            config:{
                name: 'revisado_asistente',
                fieldLabel: 'Rev',
                allowBlank: true,
                anchor: '80%',
                gwidth: 65,
                renderer:function (value, p, record){  
                            if(record.data['revisado_asistente'] == 'si')
                                return  String.format('{0}',"<div style='text-align:center'><img src = '../../../lib/imagenes/ball_green.png' align='center' width='24' height='24'/></div>");
                            else
                                return  String.format('{0}',"<div style='text-align:center'><img src = '../../../lib/imagenes/ball_white.png' align='center' width='24' height='24'/></div>");
                        },
            },
            type:'Checkbox',
            filters:{pfiltro:'plapa.revisado_asistente',type:'string'},
            id_grupo:1,
            grid:false,
            form:false
        },
        {
            config:{
                name: 'num_tramite',
                fieldLabel: 'Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:200,
                renderer:function (value, p, record){  
                            if(record.data['update_enable'] == 'si')
                                return  String.format('<font color="red">{0}</font>',value);
                            else
                                return value;
                        },
                
                
                
            },
            type:'TextField',
            filters:{pfiltro:'sol.num_tramite',type:'string'},
            bottom_filter:true,
            id_grupo:1,
            grid:true,
            form:false
        },{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 115,
				maxLength:50,
				renderer:function(value_ori,p,record){
                        
                        var value = value_ori;
                        if(value_ori == 'pagado'){
                        	value = 'contabilizado '
                        }
                        
                        if(record.data.contador_estados > 1){
                             return String.format('<div title="Número de revisiones: {1}"><b><font color="red">{0} - ({1})</font></b></div>', value, record.data.contador_estados);
                         }
                          else{
                            return String.format('<div title="Número de revisiones: {1}">{0} - ({1})</div>', value, record.data.contador_estados);
                        }}
			},
			type:'TextField',
			filters:{pfiltro:'sol.estado',type:'string'},
			bottom_filter:true,
			id_grupo:1,
			grid:true,
			form:false
		},
	   {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'tipo'
            },
            type:'Field',
            form:true 
        },
       
        
          {
            config:{
                name: 'tipo_concepto',
                fieldLabel: 'Subtipo',
                allowBlank: false,
                emptyText:'Subtipo...',
                renderer:function (value, p, record){
                	    var dato='';
                        dato = (value=='alquiler_inmueble')?'Alquiler Inmuebles':dato;
                        dato = (dato==''&&value=='consultoria_empresa')?'Consultoria de Empresas':dato;
                        dato = (dato==''&&value=='consultoria_personal')?'Consultoria de Personas':dato;
                        dato = (dato==''&&value=='servicio')?'Servicios':dato;
                        dato = (dato==''&&value=='vehiculo')?'Vehiculos':dato;
                        dato = (dato==''&&value=='inmueble')?'Inmuebles':dato;
                        dato = (dato==''&&value=='bien')?'Bienes':dato;
                        dato = (dato==''&&value=='llaveMano')?'LLave en Mano':dato;//#6
                        return String.format('{0}', dato);
                    },
                
                store:new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  []}),
               
                valueField: 'variable',
                displayField: 'valor',
                forceSelection: true,
                triggerAction: 'all',
                lazyRender: true,
                resizable:true,
                listWidth:'500',
                mode: 'local',
                wisth: 380
                },
            type:'ComboBox',
            filters:{pfiltro:'sol.tipo_concepto',type:'string'},
            id_grupo:0,
            grid:true,
            form:false
        },
           
       {
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                 allowBlank:false,
                fieldLabel:'Moneda',
                gdisplayField:'desc_moneda',//mapea al store del grid
                gwidth:50,
                 renderer:function (value, p, record){return String.format('{0}', record.data['desc_moneda']);}
             },
            type:'ComboRec',
            id_grupo:1,
            filters:{   
                pfiltro:'mon.codigo',
                type:'string'
            },
            grid:true,
            form:false
          },	     
		
        {
            config:{
                name: 'fecha_soli',
                fieldLabel: 'Fecha Sol.',
                allowBlank: false,
                disabled: false,
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'sol.fecha_soli',type:'date'},
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
   			filters:{pfiltro:'depto.nombre',type:'string'},
   		    grid:false,
   			form:false
       	},
		{
			config:{
				name: 'numero',
				fieldLabel: 'numero',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:50
			},
			type:'TextField',
			filters:{pfiltro:'sol.numero',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
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
   			bottom_filter:true,
   		    grid:true,
   			form:false
		 },
           {
            config:{
                name:'id_uo',
                hiddenName: 'id_uo',
                origen:'UO',
                fieldLabel:'UO',
                allowBlank:false,
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
            form:false
          },
        {
            config:{
                name: 'obs',
                fieldLabel: 'Instrucciones/Obs',
                allowBlank: true,
                anchor: '80%',
                renderer:function (value, p, record){
                    
                    if(record.data['instruc_rpc'])
                        return String.format('{1}, {0}, {2} ', record.data['desc_uo'],record.data['instruc_rpc'], record.data['obs']);
                    else
                        return String.format('{0}, {1} ', record.data['desc_uo'], record.data['obs']);
                    
                    
                    },
                gwidth: 150,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'ew.obs#instruc_rpc',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
          
        {
            config:{
                name:'id_funcionario_aprobador',
                hiddenName: 'id_funcionario_aprobador',
                origen:'FUNCIONARIOCAR',
                fieldLabel:'Gerencia Aprob',
                allowBlank:false,
                disabled:true,
                gwidth:200,
                valueField: 'id_funcionario',
                gdisplayField: 'desc_funcionario_apro',
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario_apro']);}
             },
            type:'ComboRec',//ComboRec
            filters:{pfiltro:'funa.desc_funcionario1',type:'string'},
            id_grupo:0,
            grid:true,
            form:false
         },
        {
            config:{
                name: 'desc_funcionario_rpc',
                fieldLabel: 'RPC',
                gwidth: 200,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'funrpc.desc_funcionario1',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        }
		,
		
		{
			config:{
				name: 'fecha_apro',
				fieldLabel: 'Fecha Aprobación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
			type:'DateField',
			filters:{pfiltro:'sol.fecha_apro',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config: {
				name: 'id_categoria_compra',
				hiddenName: 'id_categoria_compra',
				fieldLabel: 'Categoria de Compra',
				typeAhead: false,
				forceSelection: false,
				allowBlank: false,
				emptyText: 'Categorias...',
				store: new Ext.data.JsonStore({
					url: '../../sis_adquisiciones/control/CategoriaCompra/listarCategoriaCompra',
					id: 'id_categoria_compra',
					root: 'datos',
					sortInfo: {
						field: 'catcomp.nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_categoria_compra', 'nombre', 'codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'catcomp.nombre#catcomp.codigo',codigo_subsistema:'ADQ'}
				}),
				valueField: 'id_categoria_compra',
				displayField: 'nombre',
				gdisplayField: 'desc_categoria_compra',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				renderer: function(value, p, record) {
					return String.format('{0}', record.data['desc_categoria_compra']);
				},
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p>Codigo: <strong>{codigo}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {
				pfiltro: 'cat.nombre',
				type: 'string'
			},
			grid: true,
			form: false
		},
        {
            config:{
                name: 'precontrato',
                fieldLabel: 'Tipo de Contrato',
                qtip: 'Si tine un contrato de adhesion',
                allowBlank: false,
                emptyText: 'Tipo...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                gwidth: 100,
                store: ['no_necesita','contrato_nuevo','contrato_adhesion','ampliacion_contrato']
            },
            type: 'ComboBox',
            id_grupo: 2,
            filters:{
                type: 'list',
                pfiltro:'sol.tipo',
                options: ['no_necesita','contrato_nuevo','contrato_adhesion','ampliacion_contrato'],
            },
            valorInicial: 'no_necesita',
            grid:false,
            form:true
        },
        
         //#10 Adqusiciones, adiciona el campo para decidir si vamos al 87% 
        {
            config:{
                name: 'comprometer_87',
                fieldLabel: 'Comp 87%',
                qtip: 'Si compromete al 87% , en caso contrario es el 100%  (87% es cuando estemos  seguros que la adjudicación se realizara a un proveedor que emite factura con crédito fiscal)',
                allowBlank: false,
                disabled: true,/////////EGS///////30/07/2018
                emptyText: 'Tipo...',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                gwidth: 100,
                store: ['no','si']
            },
            type: 'ComboBox',
            id_grupo: 2,
            filters:{
                type: 'list',
                pfiltro:'sol.comprometer_87',
                options: ['no','si'],
            },
            valorInicial: 'no',
            grid:false,
            form:true
        },
         {
            config:{
                name:'id_proveedor',
                hiddenName: 'id_proveedor',
                origen:'PROVEEDOR',
                fieldLabel:'Proveedor Precotizacion',
                allowBlank:false,
                tinit:false,
                gwidth:200,
                valueField: 'id_proveedor',
                gdisplayField: 'desc_proveedor',
                inputType:'hidden',
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_proveedor']);}
             },
            type:'ComboRec',//ComboRec
            id_grupo:0,
            filters:{pfiltro:'pro.desc_proveedor',type:'string'},
            bottom_filter:true,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'justificacion',
				fieldLabel: 'Justificacion',
				qtip:'Justifique, ¿por que la necesidad de esta compra?',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'sol.justificacion',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'lugar_entrega',
				fieldLabel: 'Lugar Entrega',
				qtip:'Proporcionar una buena descripcion para informar al proveedor, Ejm. Entrega en oficinas de aeropuerto Cochabamba, Jaime Rivera #28',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextArea',
			filters:{pfiltro:'sol.lugar_entrega',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},	     
		
        {
            config:{
                name: 'fecha_inicio',
                fieldLabel: 'Fecha Inicio Estimada.',
                qtip:'En que se fecha se estima el inicio del servicio',
                allowBlank: false,
                disabled: false,
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'sol.fecha_soli',type:'date'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'dias_plazo_entrega',
                fieldLabel: 'Dias entrega (Calendario)',
                qtip: '¿Después de cuantos días calendario de emitida  la orden de compra se hara la entrega de los bienes?. EJM. Quedara de esta forma en la orden de Compra:  (Tiempo de entrega: X días calendario  de emitida la presente orden)',
                allowBlank: true,
                allowDecimals: false,
                width: 100,
                gwidth: 100,
                minValue: 1,
                maxLength: 10
            },
            type: 'NumberField',
            filters: { pfiltro: 'sold.cantidad', type: 'numeric' },
            id_grupo: 1,
            grid: true,
            form: false
        },
        {
            config:{
                name: 'nro_po',
                fieldLabel: 'Nro. de P.O.',
                qtip:'Ingrese el nro. de P.O.',
                allowBlank: true,
                width: 100,
                gwidth: 100,
                maxLength:255
            },
            type:'TextField',
            id_grupo:1,
            filters:{pfiltro:'sol.nro_po',type:'string'},
            grid: true,
            form: true
        },

        {
            config:{
                name: 'fecha_po',
                fieldLabel: 'Fecha de P.O.',
                qtip:'Fecha del P.O.',
                allowBlank: true,
                gwidth: 100,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            id_grupo:1,
            grid: true,
            form: true
        },
		{
			config:{
				name: 'posibles_proveedores',
				fieldLabel: 'Otros Proveedores',
				qtip:'Si tuvieramos que adicionar cotizaciones,  ¿Que proveedores podriamos consultar?',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'sol.posibles_proveedores',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'comite_calificacion',
				fieldLabel: 'Comite Calificación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'sol.comite_calificacion',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		
		{
			config:{
				name: 'extendida',
				fieldLabel: 'extendida',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:2
			},
			type:'TextField',
			filters:{pfiltro:'sol.extendida',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
		{
			config:{
				name: 'obs_presupuestos',
				fieldLabel: 'Obs Presupuestos',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
				maxLength:500
			},
			type:'Field',
			filters:{pfiltro:'sol.obs_presupuestos',type:'string'},
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
			filters:{pfiltro:'sol.estado_reg',type:'string'},
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
			filters:{pfiltro:'sol.fecha_reg',type:'date'},
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
			type:'Field',
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
			filters:{pfiltro:'sol.fecha_mod',type:'date'},
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
		},
		{
			config:{
				name: 'observacion',
				fieldLabel: 'Observacion',				
				allowBlank: true,
				anchor: '80%',
				maxLength:255
			},
			type:'TextArea',
			form:true
		}
	],
	
	title:'Solicitud de Compras',
	ActSave:'../../sis_adquisiciones/control/Solicitud/insertarSolicitud',
	ActDel:'../../sis_adquisiciones/control/Solicitud/eliminarSolicitud',
	ActList:'../../sis_adquisiciones/control/Solicitud/listarSolicitud',
	id_store:'id_solicitud',
	fields: [
		{name:'id_solicitud', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_solicitud_ext', type: 'numeric'},
		{name:'presu_revertido', type: 'string'},
		{name:'fecha_apro', type: 'date',dateFormat:'Y-m-d'},
		{name:'estado', type: 'string'},
		{name:'id_funcionario_aprobador', type: 'numeric'},
		{name:'id_moneda', type: 'numeric'},
		{name:'id_gestion', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'num_tramite', type: 'string'},
		{name:'justificacion', type: 'string'},
		{name:'id_depto', type: 'numeric'},
		{name:'lugar_entrega', type: 'string'},
		{name:'extendida', type: 'string'},
		{name:'numero', type: 'string'},
		{name:'posibles_proveedores', type: 'string'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'comite_calificacion', type: 'string'},
		{name:'id_categoria_compra', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'fecha_soli', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'id_uo', type: 'string'},
		{name:'observacion', type: 'string'}, //#11 			19/09/2018			EGS	
		'desc_funcionario',
		'desc_funcionario_apro',
		'desc_funcionario_supervisor','id_funcionario_supervisor',
		'desc_funcionario_rpc',
		'desc_uo',
		'desc_gestion',
		'desc_moneda',
		'desc_depto',
		'desc_proceso_macro',
		'desc_categoria_compra',
		'id_proceso_macro',
		'obs','instruc_rpc','desc_proveedor',
		'id_proveedor',
		'ai_habilitado',
		'id_cargo_rpc',
		'id_cargo_rpc_ai',
		'ai_habilitado',
		'tipo_concepto',
		'revisado_asistente',
		{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
		'dias_plazo_entrega', 
		'obs_presupuestos',
		'precontrato',
		'update_enable','codigo_poa','obs_poa','contador_estados',
        'nro_po',
        {name:'fecha_po', type: 'date',dateFormat:'Y-m-d'},
        {name:'importe_total', type: 'numeric'},
        {name:'comprometer_87', type: 'string'} ////////EGS/////30/07/2018
	],
	
	arrayDefaultColumHidden:['id_fecha_reg','id_fecha_mod',
	'fecha_mod','usr_reg','estado_reg','fecha_reg','usr_mod',
	'id_depto','numero','obs','id_funcionario_aprobador','desc_funcionario_rpc','fecha_apro','id_categoria_compra','justificacion',
	'lugar_entrega','fecha_inicio','dias_plazo_entrega','posibles_proveedores','comite_calificacion','extendida', 'obs_presupuestos'],
	
	
	
	
	rowExpander: new Ext.ux.grid.RowExpander({
		        tpl : new Ext.Template(
		            '<br>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Número de solicitud:&nbsp;&nbsp;</b> {numero}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Depto:&nbsp;&nbsp;</b> {desc_depto}</p>',	       
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>RPC:&nbsp;&nbsp;</b> {desc_funcionario_rpc}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Aprueba:&nbsp;&nbsp;</b> {desc_funcionario_apro}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Fecha aprobación:&nbsp;&nbsp;</b> {fecha_apro:date("d/m/Y")}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Categoría de compra:&nbsp;&nbsp;</b> {desc_categoria_compra}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Justificación:&nbsp;&nbsp;</b> {justificacion}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Intrucciones:&nbsp;&nbsp;</b> {obs}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>POA:&nbsp;&nbsp;</b> {codigo_poa} - {obs_poa}</p>',
		            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Observaciones de área de presupuestos:&nbsp;&nbsp;</b> {obs_presupuestos}</p><br>'
		            
		        )
	    }),
    loadCheckDocumentosSolWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Documentos del Proceso',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
        )
    },
    
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
       
        
        //this.getBoton('btnChequeoDocumentos').setDisabled(false);
        this.getBoton('btnChequeoDocumentosWf').setDisabled(false);
        Phx.vista.Solicitud.superclass.preparaMenu.call(this,n);
        //this.getBoton('btnReporte').setDisabled(false); 
        this.getBoton('diagrama_gantt').enable();
        this.getBoton('btnObs').enable();
        this.getBoton('btnDetalleGasto').enable();
        this.getBoton('chkpresupuesto').enable();
        
        
        
        return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.Solicitud.superclass.liberaMenu.call(this);
        if(tb){
           
            //this.getBoton('btnReporte').setDisabled(true);
            //this.getBoton('btnChequeoDocumentos').setDisabled(true);
            this.getBoton('btnChequeoDocumentosWf').setDisabled(true);
            this.getBoton('diagrama_gantt').disable();  
            this.getBoton('btnObs').disable();
            this.getBoton('btnDetalleGasto').disable();
            this.getBoton('chkpresupuesto').disable();
                 
        }
       return tb
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

    onDetalleGasto : function() {
        var rec=this.sm.getSelected();
        Phx.CP.loadWindows('../../../sis_adquisiciones/vista/solicitud_det/FormDetalleGastoSolicitud.php',
            'Subir Detalle Gasto',
            {
                modal:true,
                width:450,
                height:200
            },rec.data,this.idContenedor,'FormDetalleGastoSolicitud')
    },
	
	onButtonRepOC: function(){
                var rec=this.sm.getSelected();
				Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Solicitud/reporteOC',
                    params:{'id_solicitud':rec.data.id_solicitud,'id_proveedor':rec.data.id_proveedor},
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
		
	obtenerSolicitud:function(){
	    var d= this.sm.getSelected();
	    if(d&&d.data){
    	    if(d.data.estado == 'borrador'){
    	          return d.data.id_solicitud;
    	        }
    	    else{    
    	      return 'no_borrador';
    	    }
    	}
    	else{
    	      return 'no_seleccionado';
    	}    
	},
	actualizarSolicitudDet:function(){
      
       Phx.CP.getPagina(this.idContenedor+'-south').reload();  
        
    },
    
    
     onSolModPresupuesto:function(){                   
            var rec=this.sm.getSelected();
            
            var data = {id_funcionario:this.id_funcionario}
            Ext.apply(data,rec.data)
            
            //pop pup confirmacion contrato
            
            
                 Phx.CP.loadWindows('../../../sis_adquisiciones/vista/solicitud/SolModPresupuesto.php',
                    'Solicitar Traspaso presupuestario',
                    {
                        modal:true,
                        width:700,
                        height:500
                    },data ,this.idContenedor,'SolModPresupuesto');
     },
    onOpenObs:function() {
            var rec=this.sm.getSelected();
            
            var data = {
            	id_proceso_wf: rec.data.id_proceso_wf,
            	id_estado_wf: rec.data.id_estado_wf,
            	num_tramite: rec.data.num_tramite
            }
            
            Phx.CP.loadWindows('../../../sis_workflow/vista/obs/Obs.php',
                    'Observaciones del WF',
                    {
                        width:'80%',
                        height:'70%'
                    },
                    data,
                    this.idContenedor,
                    'Obs'
        )
    },

	//
	/*reporte_veri : function() {
		var rec = this.getSelectedData();
		var reco =this.sm.getSelected();
		var NumSelect=this.sm.getCount();		
		if(NumSelect != 0)
		{
			Phx.CP.loadingShow();
			Ext.Ajax.request({
				url:'../../sis_adquisiciones/control/Solicitud/RVerDispPre',
				params:{
					'id_proceso_wf': reco.data.id_proceso_wf,	
					'num_cotizacion': reco.data.num_cotizacion,
				},
				success:this.successExport,
				failure: this.conexionFailure,
				timeout:this.timeout,
				scope:this
			});		
		}
		else
		{
			Ext.MessageBox.alert('Alerta', 'Antes debe seleccionar un item.');
		}
	},*/
	//

    wndowsCheckPresupuesto:function(){                   
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
    
    
	sortInfo:{
		field: 'fecha_reg',
		direction: 'DESC'
	},
	bdel:true,
	bsave:false,
	//#4
	actualizarPresolicitud:function(){   
       Phx.CP.getPagina(this.idContenedor+'-xeast').reload();         
    },//#4
	}
)
</script>
