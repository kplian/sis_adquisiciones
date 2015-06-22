<?php
/**
*@package pXP
*@file    FormSolicitud.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.FormSolicitud=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_adquisiciones/control/Solicitud/insertarSolicitud',
    tam_pag: 10,
    //layoutType: 'wizard',
    layout: 'fit',
    autoScroll: false,
    constructor:function(config)
    {   this.buildComponentesDetalle();
        this.buildDetailGrid();
        this.buildGrupos();
        
        Phx.vista.FormSolicitud.superclass.constructor.call(this,config);
        this.init();    
        this.iniciarEventos();
        this.iniciarEventosDetalle();
        this.onNew();
        
    },
    buildComponentesDetalle: function(){
    	this.detCmp = {
    		       'id_concepto_ingas': new Ext.form.ComboBox({
							                name: 'id_concepto_ingas',
							                msgTarget: 'title',
							                fieldLabel: 'Concepto',
							                allowBlank: false,
							                emptyText : 'Concepto...',
							                store : new Ext.data.JsonStore({
							                            url:'../../sis_parametros/control/ConceptoIngas/listarConceptoIngasMasPartida',
							                            id : 'id_concepto_ingas',
							                            root: 'datos',
							                            sortInfo:{
							                                    field: 'desc_ingas',
							                                    direction: 'ASC'
							                            },
							                            totalProperty: 'total',
							                            fields: ['id_concepto_ingas','tipo','desc_ingas','movimiento','desc_partida','id_grupo_ots','filtro_ot','requiere_ot'],
							                            remoteSort: true,
							                            baseParams:{par_filtro:'desc_ingas#par.codigo#par.nombre_partida',movimiento:'gasto', autorizacion: 'adquisiciones'}
							                }),
							               valueField: 'id_concepto_ingas',
							               displayField: 'desc_ingas',
							               hiddenName: 'id_concepto_ingas',
							               forceSelection:true,
							               typeAhead: false,
							               triggerAction: 'all',
							               listWidth:500,
							               resizable:true,
							               lazyRender:true,
							               mode:'remote',
							               pageSize:10,
							               queryDelay:1000,
							               minChars:2,
							               qtip:'Si el conceto de gasto que necesita no existe por favor  comuniquese con el área de presupuestos para solictar la creación',
							               tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_ingas}</b></p><strong>{tipo}</strong><p>PARTIDA: {desc_partida}</p></div></tpl>',
							             }),
	              'id_centro_costo': new Ext.form.ComboRec({
						                    name:'id_c	entro_costo',
						                    msgTarget: 'title',
						                    origen:'CENTROCOSTO',
						                    fieldLabel: 'Centro de Costos',
						                    url: '../../sis_parametros/control/CentroCosto/listarCentroCostoFiltradoXDepto',
						                    emptyText : 'Centro Costo...',
						                    allowBlank: false,
						                    baseParams:{filtrar:'grupo_ep'}
						                }),
	               'id_orden_trabajo': new Ext.form.ComboRec({
						                    name:'id_orden_trabajo',
						                    msgTarget: 'title',
						                    sysorigen:'sis_contabilidad',
						                    fieldLabel: 'Orden Trabajo',
							       		    origen:'OT',
						                    allowBlank:true
						            }),
						            
					'descripcion': new Ext.form.TextField({
										name: 'descripcion',
										msgTarget: 'title',
										fieldLabel: 'descripcion',
										allowBlank: false,
										anchor: '80%',
										maxLength:1200
								}),
					'cantidad': new Ext.form.NumberField({
										name: 'cantidad',
										msgTarget: 'title',
						                fieldLabel: 'cantidad',
						                allowBlank: false,
						                maxLength:10
								}),
					'precio_unitario': new Ext.form.NumberField({
						                name: 'precio_unitario',
						                msgTarget: 'title',
						                currencyChar:' ',
						                fieldLabel: 'Prec. Unit.',
						                allowBlank: false,
						                allowDecimals: true,
						                allowNegative:false,
						                decimalPrecision:2
						            }),			
					'precio_total': new Ext.form.NumberField({
									    name: 'precio_total',
									    msgTarget: 'title',
									    readOnly: true,
									    allowBlank: true
                      		 	})
					
			  }
    		
    		
    },
    iniciarEventosDetalle: function(){
    	
        
        this.detCmp.precio_unitario.on('valid',function(field){
             var pTot = this.detCmp.cantidad.getValue() *this.detCmp.precio_unitario.getValue();
             this.detCmp.precio_total.setValue(pTot);
            } ,this);
        
       this.detCmp.cantidad.on('valid',function(field){
            var pTot = this.detCmp.cantidad.getValue() * this.detCmp.precio_unitario.getValue();
            this.detCmp.precio_total.setValue(pTot);
           
        } ,this);
        
        this.detCmp.id_concepto_ingas.on('change',function( cmb, rec, ind){
	        	    this.detCmp.id_orden_trabajo.reset();
	           },this);
	        
	    this.detCmp.id_concepto_ingas.on('select',function( cmb, rec, ind){
	        	
	        	    this.detCmp.id_orden_trabajo.store.baseParams = {
			        		                                           filtro_ot:rec.data.filtro_ot,
			        		 										   requiere_ot:rec.data.requiere_ot,
			        		 										   id_grupo_ots:rec.data.id_grupo_ots
			        		 										 };
			        this.detCmp.id_orden_trabajo.modificado = true;
			        if(rec.data.requiere_ot =='obligatorio'){
			        	this.detCmp.id_orden_trabajo.allowBlank = false;
			        	this.detCmp.id_orden_trabajo.setReadOnly(false);
			        }
			        else{
			        	this.detCmp.id_orden_trabajo.allowBlank = true;
			        	this.detCmp.id_orden_trabajo.setReadOnly(true);
			        }
			        this.detCmp.id_orden_trabajo.reset();
			        
        	
             },this);
    },
    
    onInitAdd: function(){
    	console.log('onInitAdd')
    	
    },
    onCancelAdd: function(re,save){
    	if(this.sw_init_add){
    		this.mestore.remove(this.mestore.getAt(0));
    	}
    	
    	this.sw_init_add = false;
    	this.evaluaGrilla();
    },
    onUpdateRegister: function(){
    	console.log('onUpdateRegister')
    	this.sw_init_add = false;
    },
    
    onAfterEdit:function(re, o, rec, num){
    	//set descriptins values ...  in combos boxs
    	
    	var cmb_rec = this.detCmp['id_concepto_ingas'].store.getById(rec.get('id_concepto_ingas'));
    	if(cmb_rec){
    		rec.set('desc_concepto_ingas', cmb_rec.get('desc_ingas')); 
    	}
    	
    	var cmb_rec = this.detCmp['id_orden_trabajo'].store.getById(rec.get('id_orden_trabajo'));
    	if(cmb_rec){
    		rec.set('desc_orden_trabajo', cmb_rec.get('desc_orden')); 
    	}
    	
    	var cmb_rec = this.detCmp['id_centro_costo'].store.getById(rec.get('id_centro_costo'));
    	if(cmb_rec){
    		rec.set('desc_centro_costo', cmb_rec.get('codigo_cc')); 
    	}
    	
    },
    
    evaluaRequistos: function(){
    	//valida que todos los requistosprevios esten completos y habilita la adicion en el grid
     	var i = 0;
    	sw = true
    	while( i < this.Componentes.length) {
    		
    		if(!this.Componentes[i].isValid()){
    		   sw = false;
    		   //i = this.Componentes.length;
    		}
    		i++;
    	}
    	
    	console.log('SW....', sw)
    	
    	return sw
    },
    
    bloqueaRequisitos: function(sw){
    	this.Cmp.id_depto.setDisabled(sw);
    	this.Cmp.id_moneda.setDisabled(sw);
    	this.Cmp.tipo.setDisabled(sw);
    	this.Cmp.tipo_concepto.setDisabled(sw);
    	this.Cmp.fecha_soli.setDisabled(sw);
    	this.cargarDatosMaestro();
    	
    },
    
    cargarDatosMaestro: function(){
    	
        
        this.detCmp.id_orden_trabajo.store.baseParams.fecha_solicitud = this.Cmp.fecha_soli.getValue().dateFormat('d/m/Y');
        this.detCmp.id_orden_trabajo.modificado = true;
        
        this.detCmp.id_centro_costo.store.baseParams.id_gestion = this.Cmp.id_gestion.getValue();
        this.detCmp.id_centro_costo.store.baseParams.codigo_subsistema = 'ADQ';
        this.detCmp.id_centro_costo.store.baseParams.id_depto = this.Cmp.id_depto.getValue();
        this.detCmp.id_centro_costo.modificado = true;
    	
    },
    
    evaluaGrilla: function(){
    	//al eliminar si no quedan registros en la grilla desbloquea los requisitos en el maestro
    	var  count = this.mestore.getCount();
    	console.log('total registros ...', count)
    	
    	if(count == 0){
    		this.bloqueaRequisitos(false);
    	} 
    },
    
    
    buildDetailGrid: function(){
    	
    	//cantidad,detalle,peso,totalo
        var Items = Ext.data.Record.create([{
                        name: 'cantidad',
                        type: 'int'
                    }, {
                        name: 'Concepto',
                        type: 'string'
                    },{
                        name: 'p/Unit',
                        type: 'float'
                    },{
                        name: 'Importe Original',
                        type: 'float'
                    }
                    ]);
        
        this.mestore = new Ext.data.JsonStore({
					url: '../../sis_adquisiciones/control/SolicitudDet/listarSolicitudDet',
					id: 'id_solicitud_det',
					root: 'datos',
					totalProperty: 'total',
					fields: ['id_solicitud_det','id_centro_costo','descripcion', 'precio_unitario',
					         'id_solicitud','id_orden_trabajo','id_concepto_ingas','precio_total','cantidad',
							 'desc_centro_costo','desc_concepto_ingas','desc_orden_trabajo'
					],remoteSort: true,
					baseParams: {dir:'ASC',sort:'id_solicitud_det',limit:'50',start:'0'}
				});
    	
    	this.editorDetail = new Ext.ux.grid.RowEditor({
                saveText: 'Aceptar',
                name: 'btn_editor'
               
            });
        
        var summary = new Ext.ux.grid.GridSummary();
        // al iniciar la edicion
        this.editorDetail.on('beforeedit', this.onInitAdd , this);
        
        //al cancelar la edicion
        this.editorDetail.on('canceledit', this.onCancelAdd , this);
        
        //al cancelar la edicion
        this.editorDetail.on('validateedit', this.onUpdateRegister, this);
        
        this.editorDetail.on('afteredit', this.onAfterEdit, this);
        
        
        
        
        
        
        
        this.megrid = new Ext.grid.GridPanel({
        	        layout: 'fit',
                    store:  this.mestore,
                    region: 'center',
                    split: true,
                    border: false,
                    plain: true,
                    //autoHeight: true,
                    plugins: [this.editorDetail],
                    stripeRows: true,
                    tbar: [{
                        /*iconCls: 'badd',*/
                        text: '<i class="fa fa-plus-circle fa-lg"></i> Agregar Concepto',
                        scope: this,
                        width: '100',
                        handler: function(){
                        	if(this.evaluaRequistos() === true){
                        		
	                        		 var e = new Items({
	                                cantidad: 1,
	                                detalle: '',
	                                precio_total: 0,
	                                precio_unitario: 0
	                            });
	                            this.editorDetail.stopEditing();
	                            this.mestore.insert(0, e);
	                            this.megrid.getView().refresh();
	                            this.megrid.getSelectionModel().selectRow(0);
	                            this.editorDetail.startEditing(0);
	                            this.sw_init_add = true;
	                            
	                            this.bloqueaRequisitos(true);
	                            //this.editorDetail.refreshFields(true);
                        	}
                        	else{
                        		//alert('Verifique los requisitos');
                        	}
                           
                        }
                    },{
                        ref: '../removeBtn',
                        text: '<i class="fa fa-trash fa-lg"></i> Eliminar',
                        scope:this,
                        handler: function(){
                            this.editorDetail.stopEditing();
                            var s = this.megrid.getSelectionModel().getSelections();
                            for(var i = 0, r; r = s[i]; i++){
                                this.mestore.remove(r);
                            }
                            this.evaluaGrilla();
                        }
                    }],
            
                    columns: [
                    new Ext.grid.RowNumberer(),
                    {
                        header: 'Concepto',
                        dataIndex: 'id_concepto_ingas',
                        width: 200,
                        sortable: false,
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_concepto_ingas']);},
                        editor: this.detCmp.id_concepto_ingas 
                    },
                    {
                       
                        header: 'Centro de costo',
                        dataIndex: 'id_centro_costo',
                        align: 'center',
                        width: 200,
                        renderer:function (value, p, record){return String.format('{0}', record.data['desc_centro_costo']);},
                        editor: this.detCmp.id_centro_costo 
                    },
                    {
                       
                        header: 'Orden de Trabajo',
                        dataIndex: 'id_orden_trabajo',
                        align: 'center',
                        width: 150,
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_orden_trabajo']?record.data['desc_orden_trabajo']:'');},
					    editor: this.detCmp.id_orden_trabajo 
                    },
                    {
                       
                        header: 'Description',
                        dataIndex: 'descripcion',
                        align: 'center',
                        width: 200,
                        editor: this.detCmp.descripcion 
                    },
                    {
                       
                        header: 'Cant',
                        dataIndex: 'cantidad',
                        align: 'center',
                        width: 50,
                        editor: this.detCmp.cantidad 
                    },
                    
                    
                    {
                       
                        header: 'P/Unit',
                        dataIndex: 'precio_unitario',
                        align: 'center',
                        width: 50,
                        trueText: 'Yes',
                        falseText: 'No',
                        summaryType: 'sum',
                        editor: this.detCmp.precio_unitario
                    },
                    {
                        xtype: 'numbercolumn',
                        header: 'Importe Total',
                        dataIndex: 'precio_total',
                        format: '$0,0.00',
                        width: 50,
                        sortable: false,
                        summaryType: 'sum',
                        editor: this.detCmp.precio_total 
                    }]
                });
    },
    buildGrupos: function(){
    	this.Grupos = [{
    	           	    layout: 'border',
    	           	    border: false,
    	           	     frame:true,
	                    items:[
	                      {
                        	xtype: 'fieldset',
	                        border: false,
	                        split: true,
	                        layout: 'column',
	                        region: 'north',
	                        autoScroll: true,
	                        autoHeight: true,
	                        collapseFirst : false,
	                        collapsible: true,
	                        width: '100%',
	                        //autoHeight: true,
	                        padding: '0 0 0 10',
	    	                items:[
		    	                   {
							        bodyStyle: 'padding-right:5px;',
							       
							        autoHeight: true,
							        border: false,
							        items:[
			    	                   {
			                            xtype: 'fieldset',
			                            frame: true,
			                            border: false,
			                            layout: 'form',	
			                            title: 'Tipo',
			                            width: '33%',
			                            
			                            //margins: '0 0 0 5',
			                            padding: '0 0 0 10',
			                            bodyStyle: 'padding-left:5px;',
			                            id_grupo: 0,
			                            items: [],
			                         }]
			                     },
			                     {
			                      bodyStyle: 'padding-right:5px;',
			                    
			                      border: false,
			                      autoHeight: true,
							      items: [{
			                            xtype: 'fieldset',
			                            frame: true,
			                            layout: 'form',
			                            title: ' Datos básicos ',
			                            width: '33%',
			                            border: false,
			                            //margins: '0 0 0 5',
			                            padding: '0 0 0 10',
			                            bodyStyle: 'padding-left:5px;',
			                            id_grupo: 1,
			                            items: [],
			                         }]
		                         },
			                     {
			                      bodyStyle: 'padding-right:2px;',
			                     
			                      border: false,
			                      autoHeight: true,
							      items: [{
			                            xtype: 'fieldset',
			                            frame: true,
			                            layout: 'form',
			                            title: 'Tiempo',
			                            width: '33%',
			                            border: false,
			                            //margins: '0 0 0 5',
			                            padding: '0 0 0 10',
			                            bodyStyle: 'padding-left:2px;',
			                            id_grupo: 2,
			                            items: [],
			                         }]
		                         }
    	                      ]
    	                  },
    	                    this.megrid
                         ]
                 }];
    	
    	
    },
    
    loadValoresIniciales:function() 
    {        
        
       Phx.vista.FormSolicitud.superclass.loadValoresIniciales.call(this);
        
        
        
    },
    
    successSave:function(resp)
    {
        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.panel.close();
    },
                
    
    arrayStore :{
                    'Bien':[
                                ['bien','Bienes'],
                                ['inmueble','Inmuebles'],
                                ['vehiculo','Vehiculos']
                     ],	
                     'Servicio':[
                                ['servicio','Servicios'],
                                ['consultoria_personal','Consultoria de Personas'],
                                ['consultoria_empresa','Consultoria de Empresas'],
                                ['alquiler_inmueble','Alquiler Inmuebles']
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
	       			name:'tipo',
	       			fieldLabel:'Tipo',
	       			allowBlank:false,
	       			emptyText:'Tipo...',
	       			typeAhead: true,
	       		    triggerAction: 'all',
	       		    lazyRender:true,
	       		    width: '80%',
	       		    mode: 'local',
	       		    valueField: 'estilo',
	       		    store:['Bien','Servicio','Bien - Servicio']
	       		},
	       		type: 'ComboBox',
	       		id_grupo: 0,
	       		form: true
	       	},
       
        
          {
            config:{
                name: 'tipo_concepto',
                fieldLabel: 'Subtipo',
                allowBlank: false,
                emptyText:'Subtipo...',
                store:new Ext.data.ArrayStore({
                            fields :['variable','valor'],
                            data :  []}),
               
                valueField: 'variable',
                displayField: 'valor',
                forceSelection: true,
                triggerAction: 'all',
                lazyRender: true,
                resizable:true,
                //listWidth:'500',
                mode: 'local',
                width: '80%'
             },
            type:'ComboBox',
            id_grupo:0,
            form:true
        },
		{
   			config:{
			    name:'id_depto',
			    hiddenName: 'id_depto',
			    url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
   				origen: 'DEPTO',
   				allowBlank: false,
   				fieldLabel: 'Depto',
   				width: '80%',
		        baseParams: { estado:'activo', codigo_subsistema: 'ADQ' },
   			},
   			//type:'TrigguerCombo',
   			type:'ComboRec',
   			id_grupo: 0,
   			form:true
       	},
           
       {
            config:{
                name:'id_moneda',
                origen:'MONEDA',
                allowBlank:false ,
                width: '80%',
                fieldLabel:'Moneda'
             },
            type: 'ComboRec',
            id_grupo: 0,
            form: true
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
					baseParams: {par_filtro: 'catcomp.nombre#catcomp.codigo', codigo_subsistema:'ADQ'}
				}),
				valueField: 'id_categoria_compra',
				displayField: 'nombre',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				width: '80%',
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p>Codigo: <strong>{codigo}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			form: true
		},	     
		
        {
            config:{
                name: 'fecha_soli',
                fieldLabel: 'Fecha Sol.',
                allowBlank: false,
                disabled: false,
                width: 105,
                format: 'd/m/Y'
            },
            type: 'DateField',
            id_grupo: 2,
            form: true
        },	     
		
        {
            config:{
                name: 'fecha_inicio',
                fieldLabel: 'Fecha Inicio Estimada.',
                qtip:'En que se fecha se estima el inicio del servicio',
                allowBlank: false,
                disabled: false,
                format: 'd/m/Y', 
                width: 105
            },
            type:'DateField',
            id_grupo: 2,
            form:true
        },
        {
            config:{
                name: 'dias_plazo_entrega',
                fieldLabel: 'Dias entrga',
                qtip: '¿Después de cuantos días  de emitida  la orden de compra se hara la entrega de los bienes?. EJM. Quedara de esta forma en la orden de Compra:  (Tiempo de entrega: X días Hábiles de emitida la presente orden)',
                allowBlank: true,
                allowDecimals: false,
                width: 100,
                minValue:1,
                maxLength:10
            },
            type:'NumberField',
            filters:{pfiltro:'sold.cantidad',type:'numeric'},
            id_grupo: 2,
            form:true
        },
		{
   			config:{
       		    name:'id_funcionario',
       		    hiddenName: 'id_funcionario',
   				origen: 'FUNCIONARIOCAR',
   				fieldLabel:'Funcionario',
   				allowBlank: false,
                valueField: 'id_funcionario',
                width: '80%',
   			    baseParams: { es_combo_solicitud : 'si' }
       	     },
   			type: 'ComboRec',//ComboRec
   			id_grupo: 1,
   			form: true
		 },
         {
            config:{
                name:'id_proveedor',
                hiddenName: 'id_proveedor',
                origen:'PROVEEDOR',
                fieldLabel:'Proveedor Precotizacion',
                allowBlank:false,
                tinit:false,
                width: '80%',
                valueField: 'id_proveedor'
            },
            type:'ComboRec',//ComboRec
            id_grupo: 1,
            form:true
        },
		{
			config:{
				name: 'justificacion',
				fieldLabel: 'Justificacion',
				qtip:'Justifique, ¿por que la necesidad de esta compra?',
				allowBlank: false,
				width: '100%',
				maxLength:500
			},
			type:'TextArea',
			id_grupo: 1,
			form:true
		},
		{
			config:{
				name: 'lugar_entrega',
				fieldLabel: 'Lugar Entrega',
				qtip:'Proporcionar una buena descripcion para informar al proveedor, Ejm. Entrega en oficinas de aeropuerto Cochabamba, Jaime Rivera #28',
				allowBlank: false,
				width: '100%',
				maxLength:255
			},
			type:'TextArea',
			id_grupo: 1,
			form:true
		}
	],
	title: 'Frm solicitud',
	
	iniciarEventos:function(){
        
        this.cmpFechaSoli = this.getComponente('fecha_soli');
        this.cmpIdDepto = this.getComponente('id_depto');
        this.cmpIdGestion = this.getComponente('id_gestion');
       
      
        
        //inicio de eventos 
        this.cmpFechaSoli.on('change',function(f){
        	
             this.obtenerGestion(this.cmpFechaSoli);
             this.Cmp.id_funcionario.enable();             
             this.Cmp.id_funcionario.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
             
             },this);
        
       
           
           this.Cmp.tipo.on('select',function(cmp,rec){
               console.log('rec..',rec)
               if(rec.json[0]=='Bien - Servicio'){
                   
                  this.Cmp.tipo_concepto.store.loadData(this.arrayStore['Bien'].concat(this.arrayStore['Servicio']));
               }
               else{
                   this.Cmp.tipo_concepto.store.loadData(this.arrayStore[rec.json[0]]);
               }
                if(rec.json[0] == 'Bien' ||  rec.json[0] == 'Bien - Servicio'){
                	this.Cmp.lugar_entrega.setValue('Almacenes de Oficina Cochabamba');
                	this.ocultarComponente(this.Cmp.fecha_inicio);
                	this.Cmp.dias_plazo_entrega.allowBlank = false;
                	
                	
                	
                 }
                else{
                	this.Cmp.lugar_entrega.setValue('');
                	this.mostrarComponente(this.Cmp.fecha_inicio);
                	this.Cmp.dias_plazo_entrega.allowBlank = true;
                }
                this.mostrarComponente(this.Cmp.dias_plazo_entrega);
              
           },this);
      
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
                
                this.cmpIdGestion.setValue(reg.ROOT.datos.id_gestion);
                
               
            }else{
                
                alert('ocurrio al obtener la gestion')
            } 
    },
    onEdit:function(){
       this.cmpFechaSoli.disable();
       this.cmpIdDepto.disable();        
       this.Cmp.id_categoria_compra.disable();
          
       
       this.Cmp.tipo.disable();
       this.Cmp.tipo_concepto.disable();
       this.Cmp.id_moneda.disable();
       this.Cmp.id_funcionario.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);
       //this.Cmp.fecha_soli.fireEvent('change');  
       
       if(this.Cmp.tipo.getValue() == 'Bien' ||  this.Cmp.tipo.getValue() == 'Bien - Servicio'){
            	this.ocultarComponente(this.Cmp.fecha_inicio);
            	this.Cmp.dias_plazo_entrega.allowBlank = false;
        }
        else{
        	this.mostrarComponente(this.Cmp.fecha_inicio);
        	this.Cmp.dias_plazo_entrega.allowBlank = true;
        }
        this.mostrarComponente(this.Cmp.dias_plazo_entrega);
    },
    
    onNew:function(){
    	
    	
        this.form.getForm().reset();
        this.loadValoresIniciales();
        if(this.getValidComponente(0)){
        	this.getValidComponente(0).focus(false,100);
        }
       this.cmpIdDepto.enable(); 
       this.Cmp.id_categoria_compra.enable();
       
       this.Cmp.id_funcionario.disable();
       this.Cmp.fecha_soli.enable();
       this.Cmp.fecha_soli.setValue(new Date());
       this.Cmp.fecha_soli.fireEvent('change');
       
       this.Cmp.tipo.enable();
       this.Cmp.tipo_concepto.enable();
       this.Cmp.id_moneda.enable();
       
       
       this.Cmp.id_categoria_compra.store.load({params:{start:0,limit:this.tam_pag}, 
	       callback : function (r) {
	       		if (r.length == 1 ) {	       				
	    			this.Cmp.id_categoria_compra.setValue(r[0].data.id_categoria_compra);
	    		}    
	    			    		
	    	}, scope : this
	    });
	    
	    
	    this.Cmp.id_depto.store.load({params:{start:0,limit:this.tam_pag}, 
           callback : function (r) {
                if (r.length == 1 ) {                       
                    this.Cmp.id_depto.setValue(r[0].data.id_depto);
                }    
                                
            }, scope : this
        });
	    
	    
	    this.Cmp.id_funcionario.store.load({params:{start:0,limit:this.tam_pag}, 
	       callback : function (r) {
	       		if (r.length == 1 ) {	       				
	    			this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
	    			this.Cmp.id_funcionario.fireEvent('select', r[0]);
	    		}    
	    			    		
	    	}, scope : this
	    });
	    
	    
		
           
    },
    /*
    addRegiones:function(){
   	   
   	    this.addCardWizard({ 
   	    	  id: this.idContenedor + '-reg-1',
	          url:'../../../sis_adquisiciones/vista/solicitud_det/SolicitudReqDet.php',
	          title:'¿Que vamos a comprar?', 
	          height:'50%',
	          cls:'SolicitudReqDet'
         });
         
        this.addCardWizard({
        	  id: this.idContenedor + '-reg-2', 
	          url:'../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
	          title: 'Documentos', 
	          height: '50%',
	          cls: 'DocumentoWf'
         }); 
         
         
         
   },*/
   botones: true, //desactiva botones por defecto
   
   validarTarjeta: function(ind){
   	 if(ind === 0){
   	 	return this.form.getForm().isValid();
   	 }
   	 
   	return true;
   },
   
   onValidTarjetas: function(ind, incr){
   	     console.log('onValidTarjetas sobrecargado....', ind, incr)
	   	 //pasa de 0 a 1 guardamos la solicitud de compa
	   	 if(ind === 1 && incr === 1){
	   	 	this.onSubmit({argument:{'incr': incr, 'ind': ind}});
	   	 }
	   	 //pasa de 1 a 2, load file con los datos guardados ....
	   	 if(ind === 2 && incr === 1){
	   	 	Phx.vista.FormSolicitud.superclass.onValidTarjetas.call(this, ind, incr);
	   	 }
	   	 
	   	 //pasa de 2 a 3, cargamos la interface de documentos para el tramite generado
	   	 if(ind === 2 && incr === 1){
	   	 	Phx.vista.FormSolicitud.superclass.onValidTarjetas.call(this, ind, incr);
	   	 }
	   	 //retrocede ....
	   	 if( incr === -1){
	   	 	Phx.vista.FormSolicitud.superclass.onValidTarjetas.call(this, ind, incr);
	   	 }
	   	 
	   	 
   },
   successSave: function(resp){
   	    console.log('RESP...... ', resp)
		Phx.CP.loadingHide(); 
		var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
		Phx.vista.FormSolicitud.superclass.onValidTarjetas.call(this, resp.argument.ind, resp.argument.incr);
		
		//Carga el id
		this.Cmp.id_solicitud.setValue(objRes.ROOT.datos.id_solicitud);
		//prepara para edicion la tarjeta 1
		this.onEdit();
		//Carga datos en la tarjeta 2
		
		console.log('11111111', Phx.CP.getPagina(this.idContenedor + '-reg-1').tipoInterfaz)
		
		
		console.log(this.idContenedor + '-reg-1', this.getValForm())
		
		//agregar los datos del control
		var data = {num_tramite: objRes.ROOT.datos.num_tramite ,  estado: objRes.ROOT.datos.estado};
		
		
		this.onEnablePanel(this.idContenedor + '-reg-1', Ext.apply(this.getValForm(), data));
		
	}
	
    
})    
</script>