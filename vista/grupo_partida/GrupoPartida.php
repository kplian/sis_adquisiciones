<?php
/**
*@package pXP
*@file gen-GrupoPartida.php
*@author  (admin)
*@date 09-05-2013 22:46:52
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.GrupoPartida=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.GrupoPartida.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
	},
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_grupo_partida'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name: 'id_grupo',
                inputType:'hidden'
            },
            type:'Field',
            form:true
        },
		   
        {
            config:{
                name:'id_partida',
                fieldLabel:'Partida',
                allowBlank:true,
                emptyText:'Partida...',
                store: new Ext.data.JsonStore({
                         url: '../../sis_presupuestos/control/Partida/listarPartida',
                         id: 'id_partida',
                         root: 'datos',
                         sortInfo:{
                            field: 'codigo',
                            direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_partida','codigo','nombre_partida'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'codigo#nombre_partida',sw_transaccional:'movimiento'}
                    }),
                valueField: 'id_partida',
                displayField: 'nombre_partida',
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>CODIGO:{codigo}</p><p>{nombre_partida}</p></div></tpl>',
                hiddenName: 'id_partida',
                forceSelection:true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                gwidth:280,
                anchor:'80%',       
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_partida']);}
            },
            type:'ComboBox',
            id_grupo:0,
            filters:{   
                        pfiltro:'codigo#nombre_partida',
                        type:'string'
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
			type:'TextField',
			filters:{pfiltro:'grpa.estado_reg',type:'string'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
						format: 'd/m/Y', 
						renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
			type:'DateField',
			filters:{pfiltro:'grpa.fecha_reg',type:'date'},
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
			filters:{pfiltro:'grpa.fecha_mod',type:'date'},
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
	
	title:'Partidad',
	ActSave:'../../sis_adquisiciones/control/GrupoPartida/insertarGrupoPartida',
	ActDel:'../../sis_adquisiciones/control/GrupoPartida/eliminarGrupoPartida',
	ActList:'../../sis_adquisiciones/control/GrupoPartida/listarGrupoPartida',
	id_store:'id_grupo_partida',
	fields: [
		{name:'id_grupo_partida', type: 'numeric'},
		{name:'id_partida', type: 'numeric'},
		{name:'id_grupo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'nombre_partida','desc_partida'
		
	],
	sortInfo:{
		field: 'id_grupo_partida',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_grupo:this.maestro.id_grupo};
        this.load({params:{start:0, limit:this.tam_pag}})
        
    },
    loadValoresIniciales:function()
    {
        Phx.vista.GrupoPartida.superclass.loadValoresIniciales.call(this);
        this.getComponente('id_grupo').setValue(this.maestro.id_grupo);       
    }
	}
)
</script>
		
		