<?php
/**
*@package pXP
*@file gen-Rpc.php
*@author  (admin)
*@date 29-05-2014 15:57:51
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Rpc=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Rpc.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
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
                name: 'id_cargo',
                fieldLabel: 'Cargo RPC',
                allowBlank: false,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_organigrama/control/Cargo/listarCargo',
                    id: 'id_cargo',
                    root: 'datos',
                    sortInfo: {
                        field: 'cargo.nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_cargo', 'nombre',],
                    remoteSort: true,
                    baseParams: {par_filtro: 'cargo.nombre'}
                }),
                valueField: 'id_cargo',
                displayField: 'nombre',
                gdisplayField: 'desc_cargo',
                hiddenName: 'id_cargo',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '100%',
                gwidth: 150,
                minChars: 2,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_cargo']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'car.nombre',type: 'string'},
            grid: true,
            form: true
        },
        {
            config: {
                name: 'id_cargo_ai',
                fieldLabel: 'Cargo Suplente',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_organigrama/control/Cargo/listarCargo',
                    id: 'id_cargo',
                    root: 'datos',
                    sortInfo: {
                        field: 'cargo.nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_cargo', 'nombre',],
                    remoteSort: true,
                    baseParams: {par_filtro: 'cargo.nombre'}
                }),
                valueField: 'id_cargo',
                displayField: 'nombre',
                gdisplayField: 'desc_cargo_suplente',
                hiddenName: 'id_cargo_ai',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '100%',
                gwidth: 150,
                minChars: 2,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_cargo_suplente']);
                }
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'cars.nombre',type: 'string'},
            grid: true,
            form: true
        },
            {
                config:{
                    name:'ai_habilitado',
                    fieldLabel:'Suplente Activado',
                    allowBlank:false,
                    emptyText:'Suplente Activado...',
                    
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    store:['si','no']
                    
                },
                valorInicial:'no',
                type:'ComboBox',
                id_grupo:0,
                filters:{   
                         type: 'list',
                         options: ['si','no'],    
                    },
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
				type:'Field',
				filters:{pfiltro:'rpc.estado_reg',type:'string'},
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'NumberField',
				filters:{pfiltro:'rpc.id_usuario_ai',type:'numeric'},
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
				type:'Field',
				filters:{pfiltro:'rpc.usuario_ai',type:'string'},
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
				type:'Field',
				filters:{pfiltro:'rpc.fecha_reg',type:'date'},
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
				type:'Field',
				filters:{pfiltro:'rpc.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'RPC',
	ActSave:'../../sis_adquisiciones/control/Rpc/insertarRpc',
	ActDel:'../../sis_adquisiciones/control/Rpc/eliminarRpc',
	ActList:'../../sis_adquisiciones/control/Rpc/listarRpc',
	id_store:'id_rpc',
	fields: [
		{name:'id_rpc', type: 'numeric'},
		{name:'id_cargo', type: 'numeric'},
		{name:'id_cargo_ai', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'ai_habilitado', type: 'varchar'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_cargo','desc_cargo_suplente'
		
	],
	south:
          { 
          url:'../../../sis_adquisiciones/vista/rpc_uo/RpcUo.php',
          title:'Detalle', 
          height:'50%',
          cls:'RpcUo'
    },
	
	sortInfo:{
		field: 'id_rpc',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true
	}
)
</script>
		
		