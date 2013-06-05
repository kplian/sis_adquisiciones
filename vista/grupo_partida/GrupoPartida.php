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
		this.initButtons=[this.cmbGestion];
    	//llama al constructor de la clase padre
		Phx.vista.GrupoPartida.superclass.constructor.call(this,config);
		this.init();
		this.bloquearMenus();
		this.cmbGestion.on('select',this.capturaFiltros,this);
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
                name: 'id_gestion',
                inputType:'hidden'
            },
            type:'Field',
            form:true
        },
		 
		
        {
                config:{
                    sysorigen:'sis_presupuestos',
                    name:'id_partida',
                    origen:'PARTIDA',
                    allowBlank:true,
                    fieldLabel:'Partida',
                    gdisplayField:'nombre_partida',//mapea al store del grid
                    gwidth:200,
                    // renderer:function (value, p, record){return String.format('{0}',record.data['codigo_partida'] + '-' + record.data['nombre_partida']);}
                    renderer:function(value, p, record){return String.format('{0}', record.data['desc_partida']);}
            
                 
                 },
                type:'ComboRec',
                id_grupo:0,
                filters:{   
                    pfiltro:'par.codigo#par.nombre_partida',
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
	
	cmbGestion:new Ext.form.ComboBox({
                fieldLabel: 'Gestion',
                allowBlank: false,
                emptyText:'Gestion...',
                store:new Ext.data.JsonStore(
                {
                    url: '../../sis_parametros/control/Gestion/listarGestion',
                    id: 'id_gestion',
                    root: 'datos',
                    sortInfo:{
                        field: 'gestion',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_gestion','gestion'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro:'gestion'}
                }),
                valueField: 'id_gestion',
                triggerAction: 'all',
                displayField: 'gestion',
                forceSelection:true,
                hiddenName: 'id_gestion',
                mode:'remote',
                pageSize:50,
                queryDelay:500,
                listWidth:'280',
                width:80
            }),
	capturaFiltros:function(combo, record, index){
        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        this.store.load({params:{start:0, limit:50}});  
    },
    reload:function(p){
        
        var idGes= this.cmbGestion.getValue();
        if(idGes){
            this.store.baseParams.id_gestion=idGes;
            Phx.vista.GrupoPartida.superclass.reload.call(this,p);
        }
    },
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
		{name:'usr_mod', type: 'string'},'nombre_partida','desc_partida','id_gestion'
		
	],
	sortInfo:{
		field: 'id_grupo_partida',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
	
	onReloadPage:function(m){
        this.maestro=m;
        var idGes= this.cmbGestion.getValue()
        
            this.store.baseParams={
                 id_grupo:this.maestro.id_grupo,
                 id_gestion:idGes?idGes:0,
                 start:0,
                 limit:this.tam_pag};
        
        if(idGes){
             
             this.load({params:{start:0, limit:this.tam_pag}});
        }
        
    },
    
     onButtonNew:function(n){
       
        if(this.cmbGestion.getValue()){
         
          Phx.vista.GrupoPartida.superclass.onButtonNew.call(this);
         
         }
         else
         {
            alert("seleccione una gestion primero");
            
         }   
    },
	
    
    loadValoresIniciales:function()
    {
        Phx.vista.GrupoPartida.superclass.loadValoresIniciales.call(this);
         this.Cmp.id_grupo.setValue(this.maestro.id_grupo);   
         this.Cmp.id_gestion.setValue(this.cmbGestion.getValue()); 
         this.Cmp.id_partida.store.baseParams.id_gestion = this.cmbGestion.getValue();
         this.Cmp.id_partida.modificado = true;    
    }
 }
)
</script>
		
		