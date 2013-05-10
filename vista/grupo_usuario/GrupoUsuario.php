<?php
/**
*@package pXP
*@file gen-GrupoUsuario.php
*@author  (admin)
*@date 09-05-2013 22:46:48
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.GrupoUsuario=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.GrupoUsuario.superclass.constructor.call(this,config);
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
	tam_pag:50,
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_grupo_usuario'
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
                name:'id_usuario',
                fieldLabel:'Usuario',
                allowBlank:false,
                emptyText:'Usuario...',
                store: new Ext.data.JsonStore({

                    url: '../../sis_seguridad/control/Usuario/listarUsuario',
                    id: 'id_persona',
                    root: 'datos',
                    sortInfo:{
                        field: 'desc_person',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_usuario','desc_person','cuenta'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'PERSON.nombre_completo2#cuenta'}
                }),
                valueField: 'id_usuario',
                displayField: 'desc_person',
                gdisplayField:'desc_usuario',//dibuja el campo extra de la consulta al hacer un inner join con orra tabla
                tpl:'<tpl for="."><div class="x-combo-list-item"><p>{desc_person}</p><p>CI:{ci}</p> </div></tpl>',
                hiddenName: 'id_usuario',
                forceSelection:true,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode:'remote',
                pageSize:10,
                queryDelay:1000,
                width:250,
                gwidth:280,
                minChars:2,
                turl:'../../../sis_seguridad/vista/usuario/Usuario.php',
                ttitle:'Usuarios',
               // tconfig:{width:1800,height:500},
                tdata:{},
                tcls:'usuario',
                pid:this.idContenedor,
            
                renderer:function (value, p, record){return String.format('{0}', record.data['desc_persona']);}
            },
            type:'TrigguerCombo',
            id_grupo:0,
            filters:{   
                        pfiltro:'desc_persona',
                        type:'string'
                    },
           
            grid:true,
            form:true
        },
		{
			config:{
				name: 'obs',
				fieldLabel: 'obs',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:500
			},
			type:'TextArea',
			filters:{pfiltro:'grus.obs',type:'string'},
			id_grupo:1,
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
            filters:{pfiltro:'grus.estado_reg',type:'string'},
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
			filters:{pfiltro:'grus.fecha_reg',type:'date'},
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
			filters:{pfiltro:'grus.fecha_mod',type:'date'},
			id_grupo:1,
			grid:true,
			form:false
		}
	],
	
	title:'Usuarios',
	ActSave:'../../sis_adquisiciones/control/GrupoUsuario/insertarGrupoUsuario',
	ActDel:'../../sis_adquisiciones/control/GrupoUsuario/eliminarGrupoUsuario',
	ActList:'../../sis_adquisiciones/control/GrupoUsuario/listarGrupoUsuario',
	id_store:'id_grupo_usuario',
	fields: [
		{name:'id_grupo_usuario', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario', type: 'numeric'},
		{name:'obs', type: 'string'},
		{name:'id_grupo', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},'desc_persona'
		
	],
	sortInfo:{
		field: 'id_grupo_usuario',
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
        Phx.vista.GrupoUsuario.superclass.loadValoresIniciales.call(this);
        this.getComponente('id_grupo').setValue(this.maestro.id_grupo);
    }
	}
)
</script>
		
		