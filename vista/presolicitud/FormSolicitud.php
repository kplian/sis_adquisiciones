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
		ActSave:'../../sis_adquisiciones/control/Solicitud/insertarSolicitudCompleta',
		tam_pag: 10,
		//layoutType: 'wizard',
		layout: 'fit',
		autoScroll: false,
		breset: false,
		labelSubmit: '<i class="fa fa-check"></i> Siguiente',
		
		constructor:function(config){

			//declaracion de eventos
			this.addEvents('beforesave');
			this.addEvents('successsave');


			Phx.vista.FormSolicitud.superclass.constructor.call(this,config);
			this.obtenerVariableGlobal('adq_precotizacion_obligatorio')
			this.init();
			this.iniciarEventos();
			this.onNew();

			this.Cmp.tipo_concepto.store.loadData(this.arrayStore['Bien'].concat(this.arrayStore['Servicio']));

		},

		onInitAdd: function(){


		},
		onCancelAdd: function(re,save){
			if(this.sw_init_add){
				this.mestore.remove(this.mestore.getAt(0));
			}

			this.sw_init_add = false;
			this.evaluaGrilla();
		},
		onUpdateRegister: function(){
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



			return sw
		},

		bloqueaRequisitos: function(sw){
			this.Cmp.id_depto.setDisabled(sw);
			this.Cmp.id_moneda.setDisabled(sw);

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
			//cuando esta el la inteface de presupeustos no filtra por bienes o servicios
			this.detCmp.id_concepto_ingas.store.baseParams.tipo=this.Cmp.tipo.getValue();
			this.detCmp.id_concepto_ingas.store.baseParams.id_gestion=this.Cmp.id_gestion.getValue();
			this.detCmp.id_concepto_ingas.modificado = true;

		},

		evaluaGrilla: function(){
			//al eliminar si no quedan registros en la grilla desbloquea los requisitos en el maestro
			var  count = this.mestore.getCount();
			if(count == 0){
				this.bloqueaRequisitos(false);
			}
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
				//['inmueble','Inmuebles'],
				//['vehiculo','Vehiculos']
			],
			'Servicio':[
				['servicio','Servicios'],
                //20180319 - calvarez - quitar en desarrollo tb por que usuarios VIP estan usando sin saber y no existe flujo que cubra estas 2 opciones
				//['consultoria_personal','Consultoria de Personas'],
				//['consultoria_empresa','Consultoria de Empresas'],
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
					fieldLabel: 'Tipo',
					allowBlank: false,
					emptyText: 'Tipo...',
					store: new Ext.data.ArrayStore({
						fields :['variable','valor'],
						data :  []}),

					valueField: 'variable',
					displayField: 'valor',
					forceSelection: true,
					triggerAction: 'all',
					lazyRender: true,
					resizable:true,
					mode: 'local',
					width: '80%'
				},
				type:'ComboBox',
				id_grupo:0,
				form:true
			},
			{
				config:{
					name:'id_funcionario',
					hiddenName: 'id_funcionario',
					origen: 'FUNCIONARIOCAR',
					fieldLabel:'Funcionario Solicitante',
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
					name:'id_depto',
					hiddenName: 'id_depto',
					url: '../../sis_parametros/control/Depto/listarDeptoFiltradoXUsuario',
					origen: 'DEPTO',
					allowBlank: false,
					fieldLabel: 'Depto',
					disabled: true,
					width: '80%',
					baseParams: { estado:'activo', codigo_subsistema: 'ADQ' },
				},
				type:'ComboRec',
				id_grupo: 1,
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
						baseParams: { par_filtro: 'catcomp.nombre#catcomp.codigo', codigo_subsistema: 'ADQ'}
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
					name:'id_moneda',
					origen:'MONEDA',
					allowBlank: false ,
					width: '80%',
					fieldLabel: 'Moneda'
				},
				type: 'ComboRec',
				id_grupo: 0,
				form: true
			},

			{
				config:{
					name: 'fecha_soli',
					fieldLabel: 'Fecha Solicitud',
					allowBlank: false,
					disabled: false,
					readOnly: false,
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
					fieldLabel: 'Fecha de Inicio Estimada',
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
					fieldLabel: 'Dias de Entrega (Calendario)',
					qtip: '¿Después de cuantos días calendario de emitida  la orden de compra se hara la entrega de los bienes?. EJM. Quedara de esta forma en la orden de Compra:  (Tiempo de entrega: X días calendario  a partir del dia siguiente de emitida la presente orden)',
					allowBlank: false,
					allowDecimals: false,
					width: 100,
					minValue:1,
					maxLength:10
				},
				type:'NumberField',
				filters:{pfiltro:'sold.dias_plazo_entrega',type:'numeric'},
				id_grupo: 2,
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
					width: '80%',
					valueField: 'id_proveedor'
				},
				type:'ComboRec',//ComboRec
				id_grupo: 0,
				form:true
			},
			{
				config:{
					name: 'correo_proveedor',
					fieldLabel: 'Email Proveedor',
					qtip: 'El correo del proveedor es necesario para el envió de notificaciones (como la orden de compra o invitación), asegúrese de que sea el correcto',
					allowBlank: true
				},
				type: 'TextField',
				id_grupo: 0,
				form: true
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
					fieldLabel: 'Lugar de Entrega',
					qtip:'Proporcionar una buena descripcion para informar al proveedor, Ej. Entrega en oficinas de aeropuerto Cochabamba, Jaime Rivera #28',
					allowBlank: false,
					width: '100%',
					maxLength:255
				},
				type:'TextArea',
				id_grupo: 1,
				form:true
			},
			    //#10 Adqusiciones, adiciona el campo para decidir si vamos al 87% 
	        {
	            config:{
	                name: 'comprometer_87',
	                fieldLabel: 'Comp 87%',
	                qtip: 'Si compromete al 87% , en caso contrario es el 100%  (87% es cuando estemos  seguros que la adjudicación se realizara a un proveedor que emite factura con crédito fiscal)',
	                allowBlank: false,
	                emptyText: 'Tipo...',
	                disabled: true, //RAC 27/02/"018 se bloquea esta opcion, todoas las solitudes se han al NETO"
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
	            form:true  //////EGS////30/07/2018
	        },
			{
				config:{
					name: 'precontrato',
					fieldLabel: 'Tipo de Contrato',
					qtip: 'Si tine un contrato de adhesion',
					allowBlank: false,
					disabled: true,
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
				form:true   //////EGS////30/07/2018
			},
			{
				config:{
					name: 'nro_po',
					fieldLabel: 'Nro. de P.O.',
					qtip:'Ingrese el nro. de P.O.',
					allowBlank: true,
					disabled: false,
					anchor: '80%',
					gwidth: 100,
					maxLength:255
				},
				type:'TextField',
				id_grupo:2,
				grid:false,
				form:true
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
				id_grupo:2,
				grid:false,
				form:true
			},
			{
				config:{
					name: 'observacion',
					fieldLabel: 'Observacion',
					qtip:'Observacion',
					allowBlank: true,
					height:'100',
					width:'200'			
				},
				type:'TextArea',
				id_grupo: 2,
				form:true
			}
		],
		title: 'Frm solicitud',

		iniciarEventos:function(){

			this.cmpFechaSoli = this.getComponente('fecha_soli');
			this.cmpIdDepto = this.getComponente('id_depto');
			this.cmpIdGestion = this.getComponente('id_gestion');

			this.ocultarComponente(this.Cmp.nro_po);
			this.ocultarComponente(this.Cmp.fecha_po);

			//inicio de eventos
			this.cmpFechaSoli.on('change',function(f){

				this.obtenerGestion(this.cmpFechaSoli);
				this.Cmp.id_funcionario.enable();
				this.Cmp.id_funcionario.store.baseParams.fecha = this.cmpFechaSoli.getValue().dateFormat(this.cmpFechaSoli.format);

			},this);


			this.Cmp.tipo_concepto.on('select',function(cmp,rec){

				//identificamos si es un bien o un servicio
				if(this.isInArray(rec.json, this.arrayStore['Bien'])){
					this.Cmp.tipo.setValue('Bien');
				}
				else{
					this.Cmp.tipo.setValue('Servicio');
				}

				if(this.Cmp.tipo.getValue() == 'Bien'){
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



			this.Cmp.id_funcionario.on('select', function(combo, record, index){

				if(!record.data.id_lugar){
					alert('El funcionario no tiene oficina definida');
					return
				}

				this.Cmp.id_depto.reset();
				this.Cmp.id_depto.store.baseParams.id_lugar = record.data.id_lugar;
				this.Cmp.id_depto.modificado = true;
				this.Cmp.id_depto.enable();

				this.Cmp.id_depto.store.load({params:{start:0,limit:this.tam_pag},
					callback : function (r) {
						if (r.length == 1 ) {
							this.Cmp.id_depto.setValue(r[0].data.id_depto);
						}

					}, scope : this
				});


			}, this);

			this.Cmp.id_proveedor.on('select', function(combo, record, index){

				this.Cmp.correo_proveedor.reset();
				this.Cmp.correo_proveedor.setValue(record.data.email);


			}, this);

			this.Cmp.id_categoria_compra.on('select', function(combo, record, index){

				if(combo.lastSelectionText=='Compra Internacional'){
					this.mostrarComponente(this.Cmp.nro_po);
					this.mostrarComponente(this.Cmp.fecha_po);

					Ext.Ajax.request({
						url:'../../sis_adquisiciones/control/Solicitud/listarMoneda',
						params:{nombre_moneda:'$us'},
						success:function (resp) {
							var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
							console.log(reg.ROOT.datos);
							this.Cmp.id_moneda.setValue(reg.ROOT.datos.id_moneda);
							this.Cmp.id_moneda.setRawValue(reg.ROOT.datos.moneda);
						},
						failure: this.conexionFailure,
						timeout:this.timeout,
						scope:this
					});
					
				}else if(combo.lastSelectionText=='Compra Nacional'){
					this.ocultarComponente(this.Cmp.nro_po);
					this.ocultarComponente(this.Cmp.fecha_po);

					Ext.Ajax.request({
						url:'../../sis_adquisiciones/control/Solicitud/listarMoneda',
						params:{nombre_moneda:'Bs'},
						success:function (resp) {

							var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
							console.log(reg.ROOT.datos);
							this.Cmp.id_moneda.setValue(reg.ROOT.datos.id_moneda);
							this.Cmp.id_moneda.setRawValue(reg.ROOT.datos.moneda);
						},
						failure: this.conexionFailure,
						timeout:this.timeout,
						scope:this
					});
					
				}



			}, this);

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

		onNew: function(){

			this.cmpIdDepto.disable();
			this.form.getForm().reset();
			this.loadValoresIniciales();
			if(this.getValidComponente(0)){
				this.getValidComponente(0).focus(false, 100);
			}

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

			this.Cmp.id_funcionario.store.load({params:{start:0,limit:this.tam_pag},
				callback : function (r) {
					if (r.length == 1 ) {
						this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
						this.Cmp.id_funcionario.fireEvent('select', this.Cmp.id_funcionario, r[0]);
					}

				}, scope : this
			});

		},

		onSubmit: function(o) {
			//  validar formularios
			var arra = [], i, me = this;
			me.argumentExtraSubmit = { 'json_new_records': JSON.stringify(arra, function replacer(key, value) {

				return value;
			}) };
				


			    if(this.Cmp.id_categoria_compra.getRawValue() == 'Compra Internacional') {
                    Ext.Ajax.request({
                        url: '../../sis_adquisiciones/control/Solicitud/validarNroPo',
                        params: {
                            nro_po: this.Cmp.nro_po.getValue(),
                            id_funcionario: this.Cmp.id_funcionario.getValue()

                        },
                        argument: {},
                        success: function (resp) {
                            var reg = Ext.decode(Ext.util.Format.trim(resp.responseText));
                            if (reg.ROOT.datos.v_valid == 'true') {
                                Ext.Msg.alert('Alerta', 'El P.O. Nro. <b>' + this.Cmp.nro_po.getValue() + '</b> ya fue registrado por el Funcionario <b> ' + reg.ROOT.datos.v_id_funcionario + '</b> , desea continuar el registro ');
                            }
                            else {
                                Phx.vista.FormSolicitud.superclass.onSubmit.call(this, o, undefined, true);
                            }

                        },
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                }
                else{
                	console.log('hola');
                    Phx.vista.FormSolicitud.superclass.onSubmit.call(this, o, undefined, true);
                	
                }	
				

		},

		successSave: function(resp){

			Phx.CP.loadingHide();
			var objRes = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
			//this.fireEvent('successsave',this,objRes);
            Phx.CP.getPagina(this.idContenedorPadre).reload();
            this.panel.close();
		},

		loadCheckDocumentosSolWf:function(data) {
			//TODO Eventos para cuando ce cierre o destruye la interface de documentos
			Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
				'Documentos del Proceso',
				{
					width:'90%',
					height:500
				},
				data,
				this.idContenedor,
				'DocumentoWf'
			);

		},
		
		obtenerVariableGlobal: function(param){
				
				//Verifica que la fecha y la moneda hayan sido elegidos
				Phx.CP.loadingShow();
				Ext.Ajax.request({
						url:'../../sis_seguridad/control/Subsistema/obtenerVariableGlobal',
						params:{
							codigo: param  
						},
						success: function(resp){
							Phx.CP.loadingHide();
							var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
							
							if (reg.ROOT.error) {
								Ext.Msg.alert('Error','Error a recuperar la variable global')
							} else {
								if (param == 'adq_precotizacion_obligatorio'){	
									   this.ocultarComponente(this.Cmp.id_proveedor);
									   //this.Cmp.id_proveedor.allowBlank = (reg.ROOT.datos.valor == 'no');
								}
								
							}
						},
						failure: this.conexionFailure,
						timeout: this.timeout,
						scope:this
					});
		
	    },
		
		


	})
</script>