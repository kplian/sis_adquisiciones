<?php
/**
*@package pXP
*@file gen-TipoDocumento.php
*@author  (admin)
*@date 08-02-2013 19:01:00
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoDocumento=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.TipoDocumento.superclass.constructor.call(this,config);
        this.init();
        //this.load({params:{start:0, limit:50}})
        this.bloquearMenus();
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_documento_sol'
            },
            type:'Field',
            form:true 
        },
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
                    name: 'nombre_arch_doc'
            },
            type:'Field',
            form:true 
        },
         {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'chequeado'
            },
            type:'Field',
            form:true 
        },
        {
            config:{
            	labelSeparator:'',
                inputType:'hidden',
                name: 'nombre_doc'
            },
            type:'Field',
            form:true
        },      
        {
            config:{
                name: 'nombre_tipo_doc',
                fieldLabel: 'Nombre Tipo de Documento',
                allowBlank: true,
                anchor: '80%',
                gwidth: 160,
                maxLength:255
            },
            type:'TextField',
            filters:{pfiltro:'docsol.nombre_tipo_doc',type:'string'},
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
            filters:{pfiltro:'docsol.estado_reg',type:'string'},
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
            filters:{pfiltro:'docsol.fecha_reg',type:'date'},
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
            filters:{pfiltro:'docsol.fecha_mod',type:'date'},
            id_grupo:1,
            grid:false,
            form:false
        }
    ],
    
    title:'Documento de Solicitud',
    ActSave:'../../sis_adquisiciones/control/DocumentoSol/insertarDocumentoSol',
    ActDel:'../../sis_adquisiciones/control/DocumentoSol/eliminarDocumentoSol',
    ActList:'../../sis_adquisiciones/control/DocumentoSol/listarDocumentoSol',
    id_store:'id_documento_sol',
    fields: [
        {name:'id_documento_sol', type: 'numeric'},     
        {name:'id_categoria_compra', type: 'numeric'},
        {name:'nombre_doc', type: 'string'},
        {name:'nombre_arch_doc', type: 'string'},
        {name:'nombre_tipo_doc', type: 'string'},
        {name:'chequeado', type: 'string'},
        {name:'estado_reg', type: 'string'},
        {name:'id_usuario_reg', type: 'numeric'},
        {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
        {name:'id_usuario_mod', type: 'numeric'},
        {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
        {name:'usr_reg', type: 'string'},
        {name:'usr_mod', type: 'string'},
        {name:'desc_categoria_compra', type: 'string'},
        {name:'desc_gestion', type: 'string'},
        {name:'desc_depto', type: 'string'},
        {name:'desc_proceso_macro', type: 'string'}
        
    ],
    sortInfo:{
        field: 'id_documento_sol',
        direction: 'ASC'
    },
    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams={id_categoria_compra:this.maestro.id_categoria_compra,id_solicitud:'',nombre_arch_doc:'',chequeado:''};
        this.load({params:{start:0, limit:50}})
    },
    loadValoresIniciales:function()
    {
        Phx.vista.TipoDocumento.superclass.loadValoresIniciales.call(this);
        this.getComponente('id_categoria_compra').setValue(this.maestro.id_categoria_compra);               
    },
    bdel:true,
    bsave:true
    }
)
</script>
        
        