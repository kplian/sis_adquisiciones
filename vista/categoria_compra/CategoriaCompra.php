<?php
/**
*@package pXP
*@file gen-CategoriaCompra.php
*@author  (admin)
*@date 06-02-2013 15:59:42
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CategoriaCompra=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.CategoriaCompra.superclass.constructor.call(this,config);
        this.init();
        this.load({params:{start:0, limit:50}});        
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_categoria_compra'
            },
            type:'Field',
            form:true 
        },
        {
            config:{
                name: 'codigo',
                fieldLabel: 'Código',
                allowBlank: false,
                anchor: '40%',
                gwidth: 100,
                maxLength:15
            },
            type:'TextField',
            filters:{pfiltro:'catcomp.codigo',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nombre',
                fieldLabel: 'Nombre',
                allowBlank: false,
                anchor: '60%',
                gwidth: 150,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'catcomp.nombre',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
			config: {
				name: 'id_proceso_macro',
				fieldLabel: 'Proceso',
				typeAhead: false,
				forceSelection: false,
				 hiddenName: 'id_proceso_macro',
				allowBlank: false,
				emptyText: 'Lista de Procesos...',
				store: new Ext.data.JsonStore({
					url: '../../sis_workflow/control/ProcesoMacro/listarProcesoMacro',
					id: 'id_proceso_macro',
					root: 'datos',
					sortInfo: {
						field: 'nombre',
						direction: 'ASC'
					},
					totalProperty: 'total',
					fields: ['id_proceso_macro', 'nombre', 'codigo'],
					// turn on remote sorting
					remoteSort: true,
					baseParams: {par_filtro: 'promac.nombre#promac.codigo',codigo_subsistema:'ADQ'}
				}),
				valueField: 'id_proceso_macro',
				displayField: 'nombre',
				gdisplayField: 'desc_proceso_macro',
				triggerAction: 'all',
				lazyRender: true,
				mode: 'remote',
				pageSize: 20,
				queryDelay: 200,
				listWidth:280,
				minChars: 2,
				gwidth: 170,
				renderer: function(value, p, record) {
					return String.format('{0}', record.data['desc_proceso_macro']);
				},
				tpl: '<tpl for="."><div class="x-combo-list-item"><p>{nombre}</p>Codigo: <strong>{codigo}</strong> </div></tpl>'
			},
			type: 'ComboBox',
			id_grupo: 0,
			filters: {
				pfiltro: 'pm.nombre',
				type: 'string'
			},
			grid: true,
			form: true
		},
        {
            config:{
                name: 'obs',
                fieldLabel: 'Código OC',
                qtip: 'Identifica el código del documento utilizado para generar la OC, debe coinsidir con código de correlativo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 150,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'catcomp.obs',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'min',
                fieldLabel: 'Mínimo ',
                allowBlank: true,
                anchor: '40%',
                gwidth: 100,
                maxLength:1245184
            },
            type:'NumberField',
            filters:{pfiltro:'catcomp.min',type:'numeric'},
            id_grupo:2,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'max',
                fieldLabel: 'Máximo',
                allowBlank: true,
                anchor: '40%',
                gwidth: 100,
                maxLength:1245184
            },
            type:'NumberField',
            filters:{pfiltro:'catcomp.max',type:'numeric'},
            id_grupo:2,
            grid:true,
            form:true
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
            filters:{pfiltro:'catcomp.estado_reg',type:'string'},
            id_grupo:1,
            grid:false,
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
            grid:false,
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
            filters:{pfiltro:'catcomp.fecha_reg',type:'date'},
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
            grid:false,
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
            filters:{pfiltro:'catcomp.fecha_mod',type:'date'},
            id_grupo:1,
            grid:false,
            form:false
        }
    ],
    
    title:'Categoria de Compra',
    ActSave:'../../sis_adquisiciones/control/CategoriaCompra/insertarCategoriaCompra',
    ActDel:'../../sis_adquisiciones/control/CategoriaCompra/eliminarCategoriaCompra',
    ActList:'../../sis_adquisiciones/control/CategoriaCompra/listarCategoriaCompra',
    id_store:'id_categoria_compra',
    fields: [
        {name:'id_categoria_compra', type: 'numeric'},
        {name:'id_proceso_macro', type: 'numeric'},
        {name:'desc_proceso_macro', type: 'string'},
        {name:'codigo', type: 'string'},
        {name:'nombre', type: 'string'},
        {name:'obs', type: 'string'},
        {name:'max', type: 'numeric'},
        {name:'min', type: 'numeric'},
        {name:'estado_reg', type: 'string'},
        {name:'id_usuario_reg', type: 'numeric'},
        {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
        {name:'id_usuario_mod', type: 'numeric'},
        {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
        {name:'usr_reg', type: 'string'},
        {name:'usr_mod', type: 'string'},
        
    ],
    sortInfo:{
        field: 'id_categoria_compra',
        direction: 'ASC'
    },
    east:{
          url:'../../../sis_adquisiciones/vista/documento_sol/TipoDocumento.php',
          title:'TipoDocumento', 
          width:'40%',
          cls:'TipoDocumento'
         },
    bdel:true,
    bsave:true, 
    Grupos:[{ 
        layout:'form',
        items:[
            {
                xtype:'fieldset',
                layout: 'form',
                border: true,
                title: '',
                bodyStyle: 'padding:0 10px 0;',
                columnWidth: '.5',
                items:[],
                id_grupo:1,
            },
            {
                xtype:'fieldset',
                layout: 'form',
                border: true,
                title: '',
                bodyStyle: 'padding:0 10px 0;',
                columnWidth: '.5',
                items:[],
                id_grupo:0,
            }
            ]
        }]
    }
)
</script>
        
        