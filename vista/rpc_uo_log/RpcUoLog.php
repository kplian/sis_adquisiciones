<?php
/**
*@package pXP
*@file gen-RpcUoLog.php
*@author  (admin)
*@date 03-06-2014 13:14:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RpcUoLog=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.RpcUoLog.superclass.constructor.call(this,config);
		this.init();
		//si la interface es pestanha este código es para iniciar 
          var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData()
          if(dataPadre){
             this.onEnablePanel(this, dataPadre);
          }
          else
          {
             this.bloquearMenus();
          }
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_rpc_uo_log'
			},
			type:'Field',
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
                filters:{pfiltro:'rpcl.fecha_reg',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
        },
		{
			config:{
				name: 'operacion',
				fieldLabel: 'operacion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
				type:'TextField',
				filters:{pfiltro:'rpcl.operacion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
				type:'TextField',
				filters:{pfiltro:'rpcl.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
        {
            config:{
                name: 'desc_categoria_compra',
                fieldLabel: 'Categoria',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:-5
            },
                type:'TextField',
                filters:{pfiltro:'cat.nombre',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
        },
        {
            config:{
                name: 'fecha_ini',
                fieldLabel: 'fecha_ini',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'rpcl.fecha_ini',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
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
				filters:{pfiltro:'rpcl.fecha_fin',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},
		
		{
            config:{
                name: 'desc_cargo',
                fieldLabel: 'CARGO',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:-5
            },
                type:'TextField',
                filters:{pfiltro:'ca.nombre',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
        },
		{
            config:{
                name: 'desc_cargo_ai',
                fieldLabel: 'CARGO AI',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:-5
            },
                type:'TextField',
                filters:{pfiltro:'cai.nombre',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
        },
		
		{
            config:{
                name: 'desc_uo',
                fieldLabel: 'UO',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:-5
            },
                type:'TextField',
                filters:{pfiltro:'uo.nombre_unidad',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
        },
        {
            config:{
                name: 'ai_habilitado',
                fieldLabel: 'ai_habilitado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:-5
            },
                type:'TextField',
                filters:{pfiltro:'rpcl.ai_habilitado',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
        },
		{
			config:{
				name: 'monto_min',
				fieldLabel: 'monto_min',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
				type:'NumberField',
				filters:{pfiltro:'rpcl.monto_min',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:false
		},
        {
            config:{
                name: 'monto_max',
                fieldLabel: 'monto_max',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:-5
            },
                type:'NumberField',
                filters:{pfiltro:'rpcl.monto_max',type:'numeric'},
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
                filters:{pfiltro:'rpcl.estado_reg',type:'string'},
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
				filters:{pfiltro:'rpcl.fecha_mod',type:'date'},
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
				filters:{pfiltro:'usu2.cuenta',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
        {
            config:{
                name: 'id_usuario_ai',
                fieldLabel: '',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
                type:'Field',
                filters:{pfiltro:'rpcl.id_usuario_ai',type:'numeric'},
                id_grupo:1,
                grid:false,
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
                type:'TextField',
                filters:{pfiltro:'rpcl.usuario_ai',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
        }
	],
	tam_pag:50,	
	title:'RPC LOG',
	ActSave:'../../sis_adquisiciones/control/RpcUoLog/insertarRpcUoLog',
	ActDel:'../../sis_adquisiciones/control/RpcUoLog/eliminarRpcUoLog',
	ActList:'../../sis_adquisiciones/control/RpcUoLog/listarRpcUoLog',
	id_store:'id_rpc_uo_log',
	fields: [
		{name:'id_rpc_uo_log', type: 'numeric'},
		{name:'monto_max', type: 'numeric'},
		{name:'id_rpc_uo', type: 'numeric'},
		{name:'id_categoria_compra', type: 'numeric'},
		{name:'operacion', type: 'string'},
		{name:'fecha_ini', type: 'date',dateFormat:'Y-m-d'},
		{name:'descripcion', type: 'string'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_rpc', type: 'numeric'},
		{name:'id_cargo', type: 'numeric'},
		{name:'id_cargo_ai', type: 'numeric'},
		{name:'id_uo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'ai_habilitado', type: 'string'},
		{name:'monto_min', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},'desc_cargo',
		{name:'usr_mod', type: 'string'},'desc_cargo_ai','desc_uo','desc_categoria_compra'
		
	],
	
	
	
	 onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_rpc:this.maestro.id_rpc};
        this.load({params:{start:0, limit:50}});
     },
   
	
	sortInfo:{
		field: 'rpcl.fecha_reg',
		direction: 'DESC'
	},
	bdel:false,
    bsave:false,
    bedit:false,
    bnew:false
	}
)
</script>
		
		