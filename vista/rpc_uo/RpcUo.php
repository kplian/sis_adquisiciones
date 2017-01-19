<?php
/**
*@package pXP
*@file gen-RpcUo.php
*@author  (admin)
*@date 29-05-2014 15:58:17
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RpcUo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.RpcUo.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
		
	},
			
	Atributos:[
	      
	
	
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_rpc_uo'
			},
			type:'Field',
			form:true 
		},
		{
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_rpc'
            },
            type:'Field',
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
                    name:'id_uos',
                    fieldLabel:'Unidad',
                    allowBlank:false,
                    emptyText:'Unidades que presupuestan...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_organigrama/control/Uo/listarUo',
                        id: 'id_uo',
                        root: 'datos',
                        sortInfo:{
                            field: 'nombre_unidad',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_uo','codigo','nombre_unidad','nombre_cargo','presupuesta','correspondencia'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'nombre_unidad#codigo',presupuesta:'si'}
                        
                    }),
                    valueField: 'id_uo',
                    displayField: 'nombre_unidad',
                    //tpl:'<tpl for="."><div class="x-combo-list-item">{codigo}<p>{nombre_unidad}</p> </div></tpl>',
                    hiddenName: 'id_uos',
                    
                    forceSelection:true,
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode:'remote',
                    pageSize:10,
                    queryDelay:1000,
                    width:250,
                    minChars:2,
                    enableMultiSelect:true
                
                    //renderer:function(value, p, record){return String.format('{0}', record.data['descripcion']);}

                },
                type:'AwesomeCombo',
                id_grupo:0,
                grid:false,
                form:true
        },
        
        {
            config:{
                    name:'id_uo',
                    origen:'UO',
                    fieldLabel:'Unidad',
                    allowBlank:false,
                    gdisplayField:'desc_uo',//mapea al store del grid
                    gwidth:200,
                    baseParams:{presupuesta:'si'},
                    renderer:function (value, p, record){return String.format('{0}', record.data['desc_uo']);}
                },
            type:'ComboRec',
            id_grupo:0,
            filters:{pfiltro:'uo.nombre_unidad',type:'string'},
            grid:true,
            form:true
       },
       
       {
            config:{
                name: 'monto_min',
                currencyChar:'Bs',
                fieldLabel: 'Monto Min.',
                allowBlank: false,
                gwidth: 100,
                renderer:bolFormatter
                    
            },
            type:'MoneyField',
            filters:{pfiltro:'ruo.monto_min',type:'numeric'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'monto_max',
                currencyChar:'Bs',
                fieldLabel: 'Monto Max.',
                allowBlank: true,
                gwidth: 100,
                renderer:bolFormatter
            },
            type:'MoneyField',
            filters:{pfiltro:'ruo.monto_max',type:'numeric'},
            id_grupo:0,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'fecha_ini',
                fieldLabel: 'fecha_ini',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'ruo.fecha_ini',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
        },
		{
			config:{
				name: 'fecha_fin',
				fieldLabel: 'fecha_fin',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ruo.fecha_fin',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'ruo.id_usuario_ai',type:'numeric'},
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
				type:'Field',
				filters:{pfiltro:'ruo.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'Field',
				filters:{pfiltro:'ruo.usuario_ai',type:'string'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'ruo.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'RPC UO',
	ActSave:'../../sis_adquisiciones/control/RpcUo/insertarRpcUo',
	ActDel:'../../sis_adquisiciones/control/RpcUo/eliminarRpcUo',
	ActList:'../../sis_adquisiciones/control/RpcUo/listarRpcUo',
	id_store:'id_rpc_uo',
	fields: [
		{name:'id_rpc_uo', type: 'numeric'},
		{name:'id_rpc', type: 'numeric'},
		{name:'id_uo', type: 'numeric'},
		{name:'monto_max', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'monto_min', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_categoria_compra','id_categoria_compra','desc_uo'
		
	],
	loadValoresIniciales:function()
    {
        this.Cmp.id_rpc.setValue(this.maestro.id_rpc);
        Phx.vista.RpcUo.superclass.loadValoresIniciales.call(this);
    },
    
    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_rpc:this.maestro.id_rpc};
        this.load({params:{start:0, limit:50}});
   },
   
    onButtonNew:function(){
       
       Phx.vista.RpcUo.superclass.onButtonNew.call(this);
       this.Cmp.id_uo.disable();
       this.Cmp.id_uo.hide();
       this.Cmp.id_uos.enable();
       this.Cmp.id_uos.show()
    
    },
    
    onButtonEdit:function(){
       
       Phx.vista.RpcUo.superclass.onButtonEdit.call(this);
       this.Cmp.id_uo.enable();
       this.Cmp.id_uo.show();
       this.Cmp.id_uos.disable();
       this.Cmp.id_uos.hide();
    
    },
	sortInfo:{
		field: 'id_rpc_uo',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	bedit:true
	}
)
</script>
		
		