<?php
/**
*@package pXP
*@file PlanPagoRep.php
*@author  (admin)
*@date 10-04-2013 15:43:23
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*	ISSUE    	  Fecha 		Autor				Descripcion	

*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.PlanPago=Ext.extend(Phx.gridInterfaz,{
    fheight: '80%',
    fwidth: '95%',
    accionFormulario:undefined, //define la accion que se ejcuta en formulario new o edit
    porc_ret_gar:0,//valor por defecto de retencion de garantia

    tam_pag: 50,
    bottom_filter: true,
    egrid: false,
    tipoStore: 'GroupingStore',//GroupingStore o JsonStore
    remoteGroup: true,
    groupField:'num_tramite',
    viewGrid: new Ext.grid.GroupingView({
        forceFit:false,
        //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
    }), //

    constructor:function(config){
		//definicion de grupos para fomrulario
		var me = this;
		this.Grupos = [
		            {
		                layout: 'hbox',
		                border: false,
		                defaults: {
		                   border: true
		                },            
		                items: [
		                              {
		                                xtype: 'fieldset',
		                                title: 'Tipo de Pago',
		                                autoHeight: true,
		                                //layout:'hbox',
		                                items: [],
		                                id_grupo:0,
		                                margins:'2 2 2 2'
		                             },
		                              
		                            {
		                                xtype: 'fieldset',
		                                title: 'Detalle de Pago',
		                                autoHeight: true,
		                                //layout:'hbox',
		                                items: [],
		                                margins:'2 10 2 2',
		                                id_grupo:1,
		                                flex:1
		                             },
		                              
		                            {
		                                xtype: 'fieldset',
		                                title: 'Ajustes',
		                                autoHeight: true,
		                                hiden: true,
		                                //layout:'hbox',
		                                items: [],
		                                margins:'2 10 2 2',
		                                id_grupo: 2,
		                                flex: 1
		                             },
		                              
		                            {
		                                xtype: 'fieldset',
		                                title: 'Periodo al que corresponde el gasto',
		                                autoHeight: true,
		                                hiden: true,
		                                //layout:'hbox',
		                                items: [],
		                                margins:'2 10 2 2',
		                                buttons: [{ text: 'Dividir gasto', handler: me.calcularAnticipo, scope: me, tooltip: 'Según las fechas,  ayuda con el calculo  del importe anticipado'}],
		                                id_grupo: 3,
		                                flex: 1
		                             }
		                       ]
		                  
		     }];

		//llama al constructor de la clase padre
		Phx.vista.PlanPago.superclass.constructor.call(this,config);
		this.init();
        this.addBotonesGantt();
        this.addButton('SolPlanPago',{ grupo:[0,1], text:'Sol. Plan Pago.',iconCls: 'bpdf32',disabled:true,handler:this.onBtnSolPlanPago,tooltip: '<b>Solicitud Plan Pago</b><br/> Incremeta el presupuesto exacto para proceder con el pago'});

        this.addButton('InfPago',{ grupo:[0,1], text:'Inf. Pago.',iconCls: 'bpdf32',disabled:true,handler:this.onBtnInfPago,tooltip: '<b>Información de Pago</b><br/> Exporta la información de pago en pdf'}); //#41

		this.addButton('btnChequeoDocumentosWf',
            {
                text: 'Documentos',
                grupo:[0,1], 
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosSolWf,
                tooltip: '<b>Documentos de la Solicitud</b><br/>Subir los documetos requeridos en la solicitud seleccionada.'
            }
        );

        this.addButton('btnObs',{
        	 		grupo:[0,1], 
                    text :'Obs Wf',
                    iconCls : 'bchecklist',
                    disabled: true,
                    handler : this.onOpenObs,
                    tooltip : '<b>Observaciones</b><br/><b>Observaciones del WF</b>'
          });

	},
	tam_pag:50,

	arrayStore :{
                	'TODOS':[
                	            ['devengado_pagado','Devengar y pagar (2 comprobantes)'],
                                ['devengado_pagado_1c','Devengar y pagar (1 comprobante)'],
                                ['devengado','Devengar'],
                                ['devengado_rrhh','Devengar RH'],
                                ['rendicion','Agrupar Dev y Pagar (Agrupa varios documentos)'], //es similr a un devengar y pagar pero no genera prorrateo directamente
                                ['anticipo','Anticipo Fact/Rec (Necesita Documento)'],
                                ['ant_parcial','Anticipo Parcial (Con retenciones parciales en cada pago)'],
                                ['pagado','Pagar'],
                                ['pagado_rrh','Pagar RH'],
                                ['ant_aplicado','Aplicacion de Anticipo'],
                                ['dev_garantia','Devolucion de Garantia'],
                                ['det_rendicion','Rendicion Ant'],
                                ['especial','Pago simple (sin efecto presupuestario)']
                     ],
                	
                	'INICIAL':[
                	            ['devengado_pagado','Devengar y pagar (2 comprobantes)'],
                	            ['devengado_pagado_1c','Devengar y pagar (1 comprobante)'],
                                ['devengado','Devengar'],
                                //['devengado_rrhh','Devengar RH'],
                                ['dev_garantia','Devolucion de Garantia'], //es similr a un devengar y pagar pero no genera prorrateo directamente
                                ['anticipo','Anticipo Fact/Rec (Ejecuta presupuesto, necesita Documento)'],
                                ['ant_parcial','Anticipo Parcial(Ejecuta presupuesto, Con retenciones parciales en cada pago)']
                               ],
                    
                    'ANT_PARCIAL':[
                               ['ant_parcial','Anticipo Parcial(No ejecuta presupuesto, Con retenciones parciales en cada pago)']
                               ],
                    
                    'DEVENGAR':[['pagado','Pagar'],
                    			['pagado_rrh','Pagar RH'],
                                ['ant_aplicado','Aplicacion de Anticipo']],
                    
                    'ANTICIPO':[['ant_aplicado','Aplicacion de Anticipo']],
                    
                    'RENDICION':[['det_rendicion','Rendicion Ant']],
                    
                    'ESPECIAL':[['especial','Pago simple (sin efecto presupuestario)']]
                                          
	},
	
	Atributos:[
        {
            config:{
                name: 'num_tramite',
                fieldLabel: 'Num. Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:200,
                renderer:function(value,p,record){
                    if(record.data.usr_reg=='vitalia.penia'|| record.data.usr_reg=='shirley.torrez'|| record.data.usr_reg=='patricia.lopez'|| record.data.usr_reg=='patricia.lopez'){
                        return String.format('<b><font color="orange">{0}</font></b>', value);
                    }
                    else {
                        return value;
                    }

                }
            },
            type:'TextField',
            filters:{pfiltro:'op.num_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'id_depto',
                fieldLabel: 'Depto',
                allowBlank: false,
                anchor: '80%',
                origen: 'DEPTO',
                tinit: false,
                baseParams:{tipo_filtro:'DEPTO_UO',estado:'activo',codigo_subsistema:'TES',modulo:'OP'},//parametros adicionales que se le pasan al store
                gdisplayField:'nombre_depto_obp',
                gwidth: 100
            },
            type:'ComboRec',
            filters:{pfiltro:'dep.nombre',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config: {
                name: 'id_proveedor',
                fieldLabel: 'Proveedor',
                anchor: '80%',
                tinit: false,
                allowBlank: false,
                origen: 'PROVEEDOR',
                gdisplayField: 'desc_proveedor',
                gwidth: 100,
                listWidth: '280',
                resizable: true
            },
            type: 'ComboRec',
            id_grupo: 1,
            filters:{pfiltro:'pv.desc_proveedor',type:'string'},
            bottom_filter: true,
            grid: true,
            form: true
        },
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_plan_pago'
			},
			type:'Field',
			form:true 
		},
		{
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'porc_monto_retgar'
            },
            type:'Field',
            form:true 
        },
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'porc_descuento_ley',
                    allowDecimals: true,
                    decimalPrecision: 10
            },
            type:'NumberField',
            form:true 
        },
	    {
	            //configuracion del componente
	            config:{
	                    labelSeparator:'',
	                    inputType:'hidden',
	                    name: 'tipo_excento',
	                    allowDecimals: true,
	                    decimalPrecision: 10
	            },
	            type: 'TextField',
	            form: true 
	      },
	      {
	            //configuracion del componente
	            config:{
	                    labelSeparator:'',
	                    inputType:'hidden',
	                    name: 'valor_excento',
	                    allowDecimals: true,
	                    decimalPrecision: 10
	            },
	            type: 'NumberField',
	            form: true 
	     },
        {
            config:{
                name: 'id_obligacion_pago',
                inputType:'hidden'
            },
            type:'Field',
            form:true
        },
        {
            config:{
                name: 'id_plan_pago_fk',
                inputType:'hidden',
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
                gwidth: 50,
                renderer:function (value, p, record){  
                            if(record.data['revisado_asistente'] == 'si')
                                return  String.format('{0}',"<div style='text-align:center'><img title='Revisado / Permite ver pagos relacionados'  src = '../../../lib/imagenes/ball_green.png' align='center' width='24' height='24'/></div>");
                            else
                                return  String.format('{0}',"<div style='text-align:center'><img title='No revisado / Permite ver pagos relacionados'  src = '../../../lib/imagenes/ball_white.png' align='center' width='24' height='24'/></div>");
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
                name: 'numero_op',
                fieldLabel: 'Obl. Pago',
                allowBlank: true,
                anchor: '80%',
                gwidth: 130,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'op.numero',type:'string'},
            id_grupo:1,
            grid:false,
            form:false
        } ,
        
        {
            config:{
                name: 'tiene_form500',
                fieldLabel: 'Form 500',
                allowBlank: true,
                anchor: '80%',
                gwidth: 70,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'op.numero',type:'string'},
            id_grupo:1,
            grid:false,
            form:false
        },
        
        
        
        {
            config:{
                name: 'nro_cuota',
                fieldLabel: 'Cuo. N#',
                allowBlank: true,
                gwidth: 50,
                renderer:function(value,p,record){
                       if(record.data.total_pagado==record.data.monto_ejecutar_total_mo ){
                             return String.format('<b><font color="green">{0}</font></b>', value);
                         }
                        else {
                            
                                if(record.data.total_prorrateado!=record.data.monto_ejecutar_total_mo ){
                                  return String.format('<b><font color="red">{0}</font></b>', value);
                                 }
                                 else{
                                         if(record.data.total_pagado!=record.data.monto_ejecutar_total_mo 
                                             && (record.data.tipo=='devengado'  || record.data.tipo=='devengado_pagado')){
                                             return String.format('<b><font color="orange">{0}</font></b>', value);
                                         }
                                         else{
                                             if(record.data.tipo=='pagado' || record.data.tipo=='ant_aplicado'){
                                                 return String.format('--> {0}', value);  
                                             } 
                                             else{
                                                return String.format('{0}', value);   
                                             }
                                           
                                         }
                                   
                                }
                        }
                      },
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'plapa.nro_cuota',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'estado',
                fieldLabel: 'Estado - (Rev)',
                allowBlank: true,
                renderer:function(value_ori,p,record){
                        
                        var value = value_ori;
                        if(value_ori == 'pagado'){
                        	value = 'contabilizado '
                        }
                        
                        if(record.data.total_prorrateado!=record.data.monto_ejecutar_total_mo || record.data.contador_estados > 1){
                             return String.format('<div title="Número de revisiones: {1}"><b><font color="red">{0} - ({1})</font></b></div>', value, record.data.contador_estados);
                         }
                          else{
                            return String.format('<div title="Número de revisiones: {1}">{0} - ({1})</div>', value, record.data.contador_estados);
                        }},
                anchor: '80%',
                gwidth: 100,
                maxLength:60
            },
            type:'Field',
            filters:{pfiltro:'plapa.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
       
        
         {
            config:{
                name: 'tipo',
                fieldLabel: 'Tipo de Cuota',
                allowBlank: false,
                emptyText:'Tipo de Cuoata',
                renderer:function (value, p, record){
                		console.log('record',record.data.pago_borrador);
                        var dato='';
                        dato = (dato==''&&value=='devengado')?'Devengar':dato;
                        dato = (dato==''&&value=='devengado_rrhh')?'Devengar':dato;
                       
						if (record.data.pago_borrador =='si') {
                         dato = (dato==''&&value=='devengado_pagado')?'Devengar':dato;
                        
                        } else{
                        
                        dato = (dato==''&&value=='devengado_pagado')?'Devengar y pagar (2 cbte)':dato;
                        };
                        dato = (dato==''&&value=='devengado_pagado_1c')?'Devengar y pagar (1 cbte)':dato;
                        dato = (dato==''&&value=='pagado')?'Pagar':dato;
                        dato = (dato==''&&value=='pagado_rrhh')?'Pagar':dato;
                        dato = (dato==''&&value=='anticipo')?'Anticipo Fact/Rec':dato;
                        dato = (dato==''&&value=='ant_parcial')?'Anticipo Parcial':dato;
                        dato = (dato==''&&value=='ant_rendicion')?'Ant. por Rendir':dato;
                        dato = (dato==''&&value=='dev_garantia')?'Devolucion de Garantia':dato;
                        dato = (dato==''&&value=='ant_aplicado')?'Aplicacion de Anticipo':dato;
                        dato = (dato==''&&value=='rendicion')?'Rendicion Ant.':dato;
                        dato = (dato==''&&value=='ret_rendicion')?'Detalle de Rendicion':dato;
                        dato = (dato==''&&value=='especial')?'Pago simple (s/p)':dato;
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
                wisth: 420,
                gwidth: 150,
                },
            type:'ComboBox',
            filters:{pfiltro:'plapa.tipo',type:'string'},
            id_grupo:0,
            grid:true,
            form:true
        },
                ///#1			16/102016		EGS	
        {
			config:{
				name:'pago_borrador',
				fieldLabel:'Pago a Borrador',
				typeAhead: true,
				allowBlank:true,
				triggerAction: 'all',
				emptyText:'Si o No',
				selectOnFocus:true,
				mode:'local',
				qtip: 'Devuelve El Pago Directo a Borrador',
				store:new Ext.data.ArrayStore({
					fields: ['ID', 'valor'],
					data :	[
						['si','si'],
						['no','no']
					]
				}),
				valueField:'ID',
				displayField:'valor',
				width:250,
				valorInicial:'no'							
			},
			type:'ComboBox',
			id_grupo:1,
			form:true
		},
		///#1			16/102016		EGS	
         {
            config:{
                name: 'nombre_pago',
                fieldLabel: 'Nombre Pago',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'plapa.nombre_pago',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        
        {
			config:{
				name: 'nro_sol_pago',
				fieldLabel: 'Número',
				allowBlank: true,
				renderer:function(value,p,record){
                        if(record.data.total_prorrateado!=record.data.monto_ejecutar_total_mo ){
                             return String.format('<b><font color="red">{0}</font></b>', value);
                         }
                          else{
                            return String.format('{0}', value);
                        }},
				anchor: '80%',
				gwidth: 100,
				maxLength:60
			},
			type:'TextField',
			filters:{pfiltro:'plapa.nro_sol_pago',type:'string'},
			id_grupo:1,
			grid:false,
			form:false
		},
        {
            config:{
                name: 'fecha_tentativa',
                fieldLabel: 'Fecha Tent.',
                allowBlank: false,
                gwidth: 80,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'plapa.fecha_dev',type:'date'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'id_plantilla',
                fieldLabel: 'Tipo Documento',
                allowBlank: false,
                emptyText:'Elija una plantilla...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_parametros/control/Plantilla/listarPlantilla',
                    id: 'id_plantilla',
                    root:'datos',
                    sortInfo:{
                        field:'desc_plantilla',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['id_plantilla',
                             'nro_linea',
                             'desc_plantilla',
                             'tipo','sw_tesoro', 'sw_compro','sw_monto_excento','tipo_excento','valor_excento'],
                    remoteSort: true,
                    baseParams:{par_filtro:'plt.desc_plantilla',sw_compro:'si',sw_tesoro:'si'}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_plantilla}</p></div></tpl>',
                valueField: 'id_plantilla',
                hiddenValue: 'id_plantilla',
                displayField: 'desc_plantilla',
                gdisplayField:'desc_plantilla',
                listWidth:'280',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
               
                gwidth: 250,
                minChars:2,
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_plantilla']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'pla.desc_plantilla',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_excento',
                currencyChar:' ',
                allowNegative:false,
                fieldLabel: 'Monto exento',
                allowBlank: false,
                disabled:true,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            valorInicial:0,
            filters:{pfiltro:'plapa.monto_excento',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },{
           config:{
               name: 'forma_pago',
               fieldLabel: 'Forma de Pago',
               gwidth: 100,
               maxLength:30,
               items: [
                   {boxLabel: 'Cheque',name: 'fp-auto',  inputValue: 'cheque', checked:true},
                   {boxLabel: 'Transferencia',name: 'fp-auto', inputValue: 'transferencia'}
                   //,{boxLabel: 'Caja',name: 'fp-auto', inputValue: 'Caja'}
               ]
           },
           type:'RadioGroupField',
           filters:{pfiltro:'plapa.forma_pago',type:'string'},
           id_grupo:1,
           grid:false,
           form:false
          },
        {
            config:{
                name: 'nro_cheque',
                fieldLabel: 'Número Cheque',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:255
            },
            type: 'NumberField',
            filters: {pfiltro:'plapa.nro_cheque',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'nro_cuenta_bancaria',
                fieldLabel: 'Banco y Cuenta Bancaria Dest.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:50,
                disabled:true
            },
            type:'TextField',
            filters:{pfiltro:'plapa.nro_cuenta_bancaria',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        
        {
            config:{
                name:'desc_moneda',
                fieldLabel:'Mon.',
                gwidth: 40,
            },
            type:'Field',
            id_grupo:1,
            filters:{   
                pfiltro:'mon.codigo',
                type:'string'
            },
            grid:false,
            form:false
        },
        
        
        {
            config:{
                name: 'monto',
                currencyChar:' ',
                allowNegative:false,
                fieldLabel: 'Monto a Pagar',
                allowBlank: false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.monto',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_anticipo',
                currencyChar:' ',
                allowNegative:false,
                qtip: 'Este monto incrementa el liquido pagable y figura como un anticipo',
                fieldLabel: 'Monto anticipado',
                allowBlank: false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.monto_anticipo',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descuento_anticipo',
                qtip:'Si anteriormente se le dio un anticipo parcial,  en este campo se colocan las retenciones para recuperar el anticipo',
                currencyChar:' ',
                fieldLabel: 'Desc. Anticipo',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.descuento_anticipo',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
       
       {
            config:{
                name: 'monto_retgar_mo',
                currencyChar:' ',
                fieldLabel: 'Ret. Garantia',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.monto_retgar_mo',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_no_pagado',
                currencyChar:' ',
                fieldLabel: 'Monto no pagado',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.monto_no_pagado',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'otros_descuentos',
                currencyChar:' ',
                fieldLabel: 'Multas',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.otros_descuentos',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descuento_inter_serv',
                currencyChar:' ',
                fieldLabel: 'Desc. Inter Servicio',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.descuento_inter_serv',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'descuento_ley',
                currencyChar:' ',
                fieldLabel: 'Decuentos de Ley',
                allowBlank: true,
                readOnly:true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.descuento_ley',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_ejecutar_total_mo',
                currencyChar:' ',
                fieldLabel: 'Monto a Ejecutar',
                allowBlank: true,
                readOnly:true,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.monto_ejecutar_total_mo',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        
        
        
        {
            config:{
                name: 'liquido_pagable',
                currencyChar:' ',
                fieldLabel: 'Liquido Pagable',
                allowBlank: true,
                readOnly:true,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.liquido_pagable',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
	   			config:{
				    name:'id_depto_lb',
				    hiddenName: 'id_depto_lb',
				    url: '../../sis_parametros/control/Depto/listarDepto',
	   				origen: 'DEPTO',
	   				allowBlank: false,
	   				fieldLabel: 'Libro de bancos destino',
	   				disabled: false,
	   				width: '80%',
			        baseParams: { estado:'activo', codigo_subsistema: 'TES',modulo:'LB',tipo_filtro:'DEPTO_UO' },
			        gdisplayField:'desc_depto_lb',
                    gwidth: 120
	   			},
	   			//type:'TrigguerCombo',
	   			filters:{pfiltro:'depto.nombre',type:'string'},
	   			type:'ComboRec',
	   			id_grupo: 1,
	   			form: false,
	   			grid: true
		},
        {
            config:{
                name: 'id_cuenta_bancaria',
                fieldLabel: 'Cuenta Bancaria Pago',
                allowBlank: false,
                emptyText:'Elija una Cuenta...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_tesoreria/control/CuentaBancaria/listarCuentaBancariaUsuario',
                    id: 'id_cuenta_bancaria',
                    root:'datos',
                    sortInfo:{
                        field:'id_cuenta_bancaria',
                        direction:'ASC'
                    },
                    totalProperty:'total',
                    fields: ['id_cuenta_bancaria','nro_cuenta','nombre_institucion','codigo_moneda','centro','denominacion'],
                    remoteSort: true,
                    baseParams : {
						par_filtro :'nro_cuenta'
					}
                }),
                tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{nro_cuenta}</b></p><p>Moneda: {codigo_moneda}, {nombre_institucion}</p><p>{denominacion}, Centro: {centro}</p></div></tpl>',
                valueField: 'id_cuenta_bancaria',
                hiddenValue: 'id_cuenta_bancaria',
                displayField: 'nro_cuenta',
                gdisplayField:'desc_cuenta_bancaria',
                listWidth:'280',
                forceSelection:true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:20,
                queryDelay:500,
                gwidth: 250,
                minChars:2,
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_cuenta_bancaria']);}
             },
            type:'ComboBox',
            filters:{pfiltro:'cb.nro_cuenta',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'id_cuenta_bancaria_mov',
                fieldLabel: 'Depósito',
                allowBlank: true,
                emptyText : 'Depósito...',
                store: new Ext.data.JsonStore({
                    url:'../../sis_tesoreria/control/TsLibroBancos/listarTsLibroBancosDepositosConSaldo',
                    id : 'id_cuenta_bancaria_mov',
                    root: 'datos',
                    sortInfo:{
                            field: 'fecha',
                            direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_libro_bancos','id_cuenta_bancaria','fecha','detalle','observaciones','importe_deposito','saldo'],
                    remoteSort: true,
                    baseParams:{par_filtro:'detalle#observaciones#fecha'}
               }),
               valueField: 'id_libro_bancos',
               displayField: 'importe_deposito',
               gdisplayField: 'desc_deposito',
               hiddenName: 'id_cuenta_bancaria_mov',
               forceSelection:true,
               typeAhead: false,
               triggerAction: 'all',
               listWidth:350,
               lazyRender:true,
               mode:'remote',
               pageSize:10,
               queryDelay:1000,
               anchor: '100%',
               gwidth:200,
               minChars:2,
               tpl: '<tpl for="."><div class="x-combo-list-item"><p>{detalle}</p><p>Fecha:<strong>{fecha}</strong></p><p>Importe:<strong>{importe_deposito}</strong></p><p>Saldo:<strong>{saldo}</strong></p></div></tpl>',
               renderer:function(value, p, record){return String.format('{0}', record.data['desc_deposito']);}
            },
            type:'ComboBox',
            filters:{pfiltro:'cbanmo.detalle#cbanmo.nro_doc_tipo',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'obs_wf',
                fieldLabel: 'Obs',
                allowBlank: true,
                anchor: '80%',
                gwidth: 300,
                maxLength:1000
            },
            type:'TextArea',
            filters:{pfiltro:'ew.obs',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'fecha_dev',
                fieldLabel: 'Fecha Dev.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'plapa.fecha_dev',type:'date'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'fecha_pag',
                fieldLabel: 'Fecha Pago',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'plapa.fecha_pag',type:'date'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'obs_descuentos_anticipo',
                fieldLabel: 'Obs. Desc. Antic.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:300
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_descuentos_anticipo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'obs_monto_no_pagado',
                fieldLabel: 'Obs. Pago',
                qtip:'Estas observaciones van a la glosa del comprobante que se genere',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:800
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_monto_no_pagado',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config: {
                name: 'codigo_tipo_anticipo',
                fieldLabel: 'Tipo Anticipo',
                anchor: '95%',
                tinit: false,
                allowBlank: false,
                origen: 'CATALOGO',
                gdisplayField: 'tipo',
                hiddenName: 'id_tipo',
                gwidth: 55,

                baseParams:{
                    cod_subsistema:'TES',
                    catalogo_tipo:'tipo_anticipo'

                },
                valueField: 'codigo',
                hidden: true
            },
            type: 'ComboRec',
            id_grupo: 1,

            filters:{pfiltro:'plapa.tipo',type:'string'},

            grid: true,
            form: true
        },
        {
            config:{
                name: 'obs_otros_descuentos',
                fieldLabel: 'Obs. otros desc.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:300
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_otros_descuentos',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'obs_descuentos_ley',
                fieldLabel: 'Obs. desc. ley',
                allowBlank: true,
                anchor: '80%',
                readOnly:true,
                gwidth: 100,
                maxLength:300
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_descuentos_ley',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'obs_descuento_inter_serv',
                fieldLabel: 'Obs. desc. inter. serv.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:300
            },
            type:'TextArea',
            filters:{pfiltro:'plapa.obs_descuento_inter_serv',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'desc_funcionario1',
                fieldLabel: 'Fun Solicitante',
                allowBlank: true,
                anchor: '80%',
                gwidth: 250,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'cecos',
                fieldLabel: 'Cecos',
                allowBlank: true,
                anchor: '80%',
                gwidth: 450,
                maxLength:450
            },
            type:'TextArea',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'monto_ajuste_ag',
                currencyChar:' ',
                fieldLabel: 'Ajuste Anterior Gestión',
                qtip:'Si en la anterior gestión el proveedor quedo con anticipo a favor de nuestra empresa, acá colocamos el monto que queremos cubrir con dicho sobrante',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.descuento_inter_serv',type:'numeric'},
            id_grupo:2,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_ajuste_siguiente_pag',
                currencyChar:' ',
                fieldLabel: 'Ajuste Anticipo siguiente',
                qtip:'Si el anticipo no alcanza para cubrir, acá colocamos el monto a cubrir con el siguiente anticipo',
                allowBlank: true,
                allowNegative:false,
                gwidth: 100,
                maxLength:1245186
            },
            type:'MoneyField',
            filters:{pfiltro:'plapa.descuento_inter_serv',type:'numeric'},
            id_grupo:2,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'fecha_costo_ini',
                fieldLabel: 'Fecha Inicio.',
                allowBlank: true,
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters: { pfiltro: 'plapa.fecha_costo_ini', type: 'date' },
            id_grupo: 3,
            grid: true,
            form: true
        },
        {
            config:{
                name: 'fecha_costo_fin',
                fieldLabel: 'Fecha Fin.',
                allowBlank: true,
                gwidth: 100,
                        format: 'd/m/Y', 
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type: 'DateField',
            filters: {pfiltro:'plapa.fecha_costo_fin',type:'date'},
            id_grupo: 3,
            grid: true,
            form: true
        },
        {
            config:{
                name: 'funcionario_wf',
                fieldLabel: 'Funcionario Res WF',
                anchor: '80%',
                gwidth: 250
            },
            type:'Field',
            filters:{pfiltro:'funwf.desc_funcionario1',type:'string'},
            bottom_filter: true,
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
            filters:{pfiltro:'plapa.estado_reg',type:'string'},
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
			filters:{pfiltro:'plapa.fecha_reg',type:'date'},
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
			filters:{pfiltro:'plapa.fecha_mod',type:'date'},
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
			filters: { pfiltro: 'usu2.cuenta', type:'string'} ,
			id_grupo: 1,
			grid: true,
			form: false
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'desc_depto_conta_pp'
			},
			type:'Field',
			form:true 
		}
	],
	
	title:'Plan Pago',
	ActSave:'../../sis_tesoreria/control/PlanPago/insertarPlanPago',
	ActDel:'../../sis_tesoreria/control/PlanPago/eliminarPlanPago',
	ActList:'../../sis_adquisiciones/control/PlanPagoRep/listarPlanPagoRep',
	id_store:'id_plan_pago',
	fields: [

		{name:'id_plan_pago', type: 'numeric'},
		'id_obligacion_pago',
		{name:'estado_reg', type: 'string'},
		{name:'nro_cuota', type: 'numeric'},
		{name:'monto_ejecutar_totamonto_ejecutar_totall_mb', type: 'numeric'},
		{name:'nro_sol_pago', type: 'string'},
		{name:'tipo_cambio', type: 'numeric'},
		{name:'fecha_pag', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'fecha_tentativa', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_dev', type: 'date',dateFormat:'Y-m-d'},
		{name:'estado', type: 'string'},
		{name:'tipo_pago', type: 'string'},
		
		{name:'descuento_anticipo_mb', type: 'numeric'},
		{name:'obs_descuentos_anticipo', type: 'string'},
		{name:'id_plan_pago_fk', type: 'numeric'},
		
		{name:'id_plantilla', type: 'numeric'},
		{name:'descuento_anticipo', type: 'numeric'},
		{name:'otros_descuentos', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'obs_monto_no_pagado', type: 'string'},
		{name:'obs_otros_descuentos', type: 'string'},
		{name:'monto', type: 'numeric'},
		{name:'id_comprobante', type: 'numeric'},
		{name:'nombre_pago', type: 'string'},
		{name:'monto_no_pagado_mb', type: 'numeric'},
		{name:'monto_mb', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'id_cuenta_bancaria', type: 'numeric'},
		{name:'otros_descuentos_mb', type: 'numeric'},
		{name:'total_prorrateado', type: 'numeric'},
		{name:'monto_ejecutar_total_mo', type: 'numeric'},
		{name:'forma_pago', type: 'string'},
		{name:'monto_no_pagado', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		'liquido_pagable',
		{name:'total_pagado', type: 'numeric'},
		{name:'monto_retgar_mo', type: 'numeric'},
		{name:'descuento_ley', type: 'numeric'},
		{name:'porc_descuento_ley', type: 'numeric'},
		{name:'porc_monto_excento_var', type: 'numeric'},
		
		'desc_plantilla','desc_cuenta_bancaria','sinc_presupuesto','obs_descuentos_ley',
		{name:'nro_cheque', type: 'numeric'},
		{name:'nro_cuenta_bancaria', type: 'string'},
		{name:'id_cuenta_bancaria_mov', type: 'numeric'},
		{name:'desc_deposito', type: 'string'},
		'numero_op',
		'id_estado_wf',
		'id_depto_conta',
		'id_moneda','tipo_moneda','desc_moneda',
		'num_tramite','monto_excento',
		'proc_monto_excento_var','obs_wf','descuento_inter_serv',
		'obs_descuento_inter_serv','porc_monto_retgar','desc_funcionario1','revisado_asistente',
		{name:'fecha_conformidad', type: 'date',dateFormat:'Y-m-d'},
		'conformidad',
		'tipo_obligacion',
		'monto_ajuste_ag',
		'monto_ajuste_siguiente_pag','pago_variable','monto_anticipo','contador_estados',
		{name:'fecha_costo_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_costo_fin', type: 'date',dateFormat:'Y-m-d'},
		'id_depto_conta_pp','desc_depto_conta_pp','funcionario_wf','tiene_form500',
		'id_depto_lb','desc_depto_lb','prioridad_lp',{name:'ultima_cuota_dev',type:'numeric'},'id_gestion','id_periodo',
        {name:'pago_borrador', type: 'string'},
        {name:'codigo_tipo_anticipo', type: 'string'},
        {name:'id_depto', type: 'numeric'},'nombre_depto_obp',
        {name:'id_proveedor', type: 'numeric'},'desc_proveedor',
        {name:'cecos', type: 'string'},

    ],
	
   arrayDefaultColumHidden:['id_fecha_reg','id_fecha_mod',
'fecha_mod','usr_reg','usr_mod','estado_reg','fecha_reg','numero_op','id_plantilla','monto_excento','forma_pago','nro_cheque','nro_cuenta_bancaria',
'descuento_anticipo','monto_retgar_mo','monto_no_pagado','otros_descuentos','descuento_inter_serv','descuento_ley','id_depto_lb',
'id_depto_lb','id_cuenta_bancaria','id_cuenta_bancaria_mov','obs_wf','fecha_dev','fecha_pag','obs_descuentos_anticipo','obs_monto_no_pagado',
'obs_otros_descuentos','obs_descuentos_ley','obs_descuento_inter_serv','monto_ajuste_ag','monto_ajuste_siguiente_pag','fecha_costo_ini',
'fecha_costo_fin','funcionario_wf','monto_anticipo','monto','monto_ejecutar_total_mo'],

   bedit:false,
   bnew:false,
   bdel:false,
   rowExpander: new Ext.ux.grid.RowExpander({
	        tpl : new Ext.Template(
	            '<br>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Obligación de pago:&nbsp;&nbsp;</b> {numero_op}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Documento:&nbsp;&nbsp;</b> {desc_plantilla}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Monto:&nbsp;&nbsp;</b> {monto}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Monto Excento:&nbsp;&nbsp;</b> {monto_excento}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Anticipo:&nbsp;&nbsp;</b> {monto_anticipo}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Descuento Anticipo:&nbsp;&nbsp;</b> {descuento_anticipo}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Retención de garantia:&nbsp;&nbsp;</b> {monto_retgar_mo}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Monto que no se pagara:&nbsp;&nbsp;</b> {monto_no_pagado}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Multas:&nbsp;&nbsp;</b> {otros_descuentos}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Descuento por intercambio de servicios:&nbsp;&nbsp;</b> {descuento_inter_serv}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Descuentos de Ley:&nbsp;&nbsp;</b> {descuento_ley}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Total a ejecutar presupeustariamente:&nbsp;&nbsp;</b> {monto_ejecutar_total_mo}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Liquido pagable:&nbsp;&nbsp;</b> {liquido_pagable}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Libro de Bancos:&nbsp;&nbsp;</b> {desc_depto_lb}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Cuenta bancaria:&nbsp;&nbsp;</b> {desc_cuenta_bancaria}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Deposito:&nbsp;&nbsp;</b> {desc_deposito}</p>',
	            '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Intrucciones:&nbsp;&nbsp;</b> {obs_wf}</p><br>'
	        )
    }),

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
    diagramGantt : function (){
        var data=this.sm.getSelected().data.id_proceso_wf;
        Phx.CP.loadingShow();
        Ext.Ajax.request({
            url: '../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
            params: { 'id_proceso_wf': data },
            success: this.successExport,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
    },

    diagramGanttDinamico : function(){
        var data=this.sm.getSelected().data.id_proceso_wf;
        window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+data)
    },
   onBtnInfPago:function(){

        var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/PlanPago/ReporteInfPago',
            params:{'id_plan_pago':rec.data.id_plan_pago},
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
    onBtnSolPlanPago:function(){
        var rec=this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_tesoreria/control/PlanPago/solicitudPlanPago',
            params:{'id_plan_pago':rec.data.id_plan_pago,id_obligacion_pago:rec.data.id_obligacion_pago},
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

     loadCheckDocumentosSolWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            
            if(this.nombreEstadoVista == 'vbconta'){
            	 rec.data.check_fisico = 'si';
            }

            var tmp = {};
            tmp = Ext.apply(tmp, rec.data);
           
     		if(rec.data.estado == 'vbgerente'){
            	 rec.data.esconder_toogle = 'si';
            }
            
     		Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Chequear documento del WF',
                    {
                        width:'90%',
                        height:500
                    },
                    Ext.apply(tmp,{
                    	 tipo: 'plan_pago',
                    	 lblDocProcCf: 'Solo doc de Pago',
                    	 lblDocProcSf: 'Todo del Trámite',
                    	 todos_documentos: 'si'
                    	 
                    	 }),
                    this.idContenedor,
                    'DocumentoWf'
          );
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
    onReloadPage:function(param){

        var me = this;
        this.initFiltro(param);
    },

    initFiltro: function(param){
        this.store.baseParams=param;
        this.load( { params: { start:0, limit: this.tam_pag } });
    },

})
</script>