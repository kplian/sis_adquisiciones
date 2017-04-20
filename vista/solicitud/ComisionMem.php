<?php
/**
 *@package pXP
 *@file gen-Compensacion.php
 *@author  (admin)
 *@date 11-08-2016 15:38:39
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ComisionMem=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.ComisionMem.superclass.constructor.call(this,config);
                this.init();
                this.load({params:{start:0, limit:this.tam_pag}})
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_integrante'
                    },
                    type:'Field',
                    form:true
                },

                {
                    config:{
                        name:'id_funcionario',
                        origen:'FUNCIONARIO',
                        tinit:true,
                        fieldLabel:'Miembro Comisión',
                        allowBlank:true,
                        gwidth:200,
                        valueField: 'id_funcionario',
                        gdisplayField:'desc_funcionario1',//mapea al store del grid
                        anchor: '100%',
                        gwidth:200,
                        renderer:function (value, p, record){return String.format('{0}', record.data['desc_funcionario1']);}
                    },
                    type:'ComboRec',
                    id_grupo:0,
                    filters:{
                        pfiltro:'FUN.desc_funcionario1::varchar',
                        type:'string'
                    },

                    grid:true,
                    form:true
                },
                {
                    config:{
                        name:'id_depto',
                        origen:'DEPTO',
                        tinit:true,
                        fieldLabel:'Departamento',
                        gdisplayField:'desc_depto',//mapea al store del grid
                        anchor: '100%',
                        gwidth:200,
                        renderer:function (value, p, record){return String.format('{0}', record.data['desc_depto']);}
                    },
                    type:'ComboRec',
                    id_grupo:0,
                    filters:{
                        pfiltro:'DEPTO.nombre',
                        type:'string'
                    },

                    grid:true,
                    form:true
                }
            ],
            tam_pag:50,
            title:'Comision',
            ActSave:'../../sis_adquisiciones/control/ComisionMem/insertarComision',
            ActDel:'../../sis_adquisiciones/control/ComisionMem/eliminarComision',
            ActList:'../../sis_adquisiciones/control/ComisionMem/listarComision',
            id_store:'id_integrante',
            fields: [
                {name:'id_integrante', type: 'numeric'},
                {name:'id_funcionario', type: 'numeric'},
                {name:'id_depto', type: 'string'},
                {name:'desc_funcionario1', type: 'string'},
                {name:'desc_depto', type: 'string'}
            ],
            sortInfo:{
                field: 'id_integrante',
                direction: 'ASC'
            },
            bdel:true,
            bsave:false,
            fwidth:'35%',
            fheight: '28%'

        }
    )
</script>

