<?php
/**
*@package pXP
*@file gen-Solicitud.php
*@author  (admin)
*@date 19-02-2013 12:12:51
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
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
		

		this.addButton('btnReporte',{
            text :'Reporte Solicitud de Compra',
            iconCls : 'bpdf32',
            disabled: true,
            handler : this.onButtonSolicitud,
            tooltip : '<b>Reporte Solicitud de Compra</b><br/><b>Reporte Solicitud de Compra</b>'
  });
  

	 this.addButton('btnChequeoDocumentos',
            {
                text: 'Chequear Documentos',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSol,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );
				
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
        },{
			config:{
				name: 'estado',
				fieldLabel: 'estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:50
			},
			type:'TextField',
			filters:{pfiltro:'sol.estado',type:'string'},
			id_grupo:1,
			grid:true,
			form:false
		},
	       	{
	       		config:{
	       			name:'tipo',
	       			fieldLabel:'Tipo',
	       			allowBlank:false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    mode: 'local',
	       		    valueField: 'estilo',
	       		    gwidth: 100,
	       		    store:['Bien','Servicio','Bien - Servicio']
	       		},
	       		type:'ComboBox',
	       		id_grupo:0,
	       		filters:{	
	       		         type: 'list',
	       				 options: ['Bien','Servicio','Bien - Servicio'],	
	       		 	},
	       		grid:true,
	       		form:true
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
            form:true
          },	     
		
        {
            config:{
                name: 'fecha_soli',
                fieldLabel: 'Fecha Sol.',
                allowBlank: false,
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'sol.fecha_soli',type:'date'},
            id_grupo:1,
            grid:true,
            form:true
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
   			        gwidth:180,
	   				baseParams:{estado:'activo',codigo_subsistema:'ADQ'},//parametros adicionales que se le pasan al store
	      			renderer:function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
   			},
   			//type:'TrigguerCombo',
   			type:'ComboRec',
   			id_grupo:0,
   			filters:{pfiltro:'depto.nombre',type:'string'},
   		    grid:false,
   			form:true
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
                name: 'obs',
                fieldLabel: 'Instrucciones/Obs',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'ew.obs',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
   	      
         {
            config:{
                name:'id_funcionario_aprobador',
                hiddenName: 'id_funcionario_aprobador',
                origen:'FUNCIONARIOCAR',
                fieldLabel:'Supervisor',
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
            form:true
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
			config:{
				name: 'lugar_entrega',
				fieldLabel: 'Lug. Entrega',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:255
			},
			type:'TextArea',
			filters:{pfiltro:'sol.lugar_entrega',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'justificacion',
				fieldLabel: 'Justificacion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'sol.justificacion',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
		},
		{
			config:{
				name: 'posibles_proveedores',
				fieldLabel: 'Proveedores',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'sol.posibles_proveedores',type:'string'},
			id_grupo:1,
			grid:true,
			form:true
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
			form:true
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
			form: true
		},
		{
			config:{
				name: 'num_tramite',
				fieldLabel: 'Tramite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 150,
				maxLength:200
			},
			type:'TextField',
			filters:{pfiltro:'sol.num_tramite',type:'string'},
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
		'desc_funcionario',
		'desc_funcionario_apro',
		'desc_funcionario_rpc',
		'desc_uo',
		'desc_gestion',
		'desc_moneda',
		'desc_depto',
		'desc_proceso_macro',
		'desc_categoria_compra',
		'id_proceso_macro',
		'obs'
		
	],
	
	
       loadCheckDocumentosSol:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_adquisiciones/vista/documento_sol/ChequeoDocumentoSol.php',
                    'Chequeo de documentos de la solicitud',
                    {
                        width:900,
                        height:600
                    },
                    rec.data,
                    this.idContenedor,
                    'ChequeoDocumentoSol'
        )
    },
    preparaMenu:function(n){
      var data = this.getSelectedData();
      var tb =this.tbar;
       
        
        this.getBoton('btnChequeoDocumentos').setDisabled(false);

        Phx.vista.Solicitud.superclass.preparaMenu.call(this,n);
        this.getBoton('btnReporte').setDisabled(false); 
        
         return tb 
     }, 
     liberaMenu:function(){
        var tb = Phx.vista.Solicitud.superclass.liberaMenu.call(this);
        if(tb){
           
            this.getBoton('btnReporte').setDisabled(true);
            this.getBoton('btnChequeoDocumentos').setDisabled(true);           
        }
       return tb
    },    
       
	onButtonSolicitud:function(){
	    var rec=this.sm.getSelected();
                console.debug(rec);
                Ext.Ajax.request({
                    url:'../../sis_adquisiciones/control/Solicitud/reporteSolicitud',
                    params:{'id_solicitud':rec.data.id_solicitud},
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
		field: 'id_solicitud',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false
	}
)
</script>	
		