<?php
/**
 *@package pXP
 *@file    FormSolicitudDet.php
 *@author  Gonzalo Sarmiento Sejas
 *@date    05-06-2017
 *@description permite subir archivo AIRBP para cargar facturas al libro de compras
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormDetalleGastoSolicitud=Ext.extend(Phx.frmInterfaz,{

            constructor:function(config)
            {
                Phx.vista.FormDetalleGastoSolicitud.superclass.constructor.call(this,config);
                this.init();
                this.loadValoresIniciales();
            },

            loadValoresIniciales:function()
            {
                Phx.vista.FormDetalleGastoSolicitud.superclass.loadValoresIniciales.call(this);
                this.getComponente('id_solicitud').setValue(this.id_solicitud);
            },

            successSave:function(resp)
            {
                Phx.CP.loadingHide();
                Phx.CP.getPagina(this.idContenedorPadre).reload();
                this.panel.close();
            },


            Atributos:[
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_solicitud'

                    },
                    type:'Field',
                    form:true

                },
                {
                    config:{
                        name: 'codigo',
                        fieldLabel: 'Codigo Archivo',
                        allowBlank:false,
                        emptyText:'Obtener de...',
                        triggerAction: 'all',
                        lazyRender:true,
                        mode: 'local',
                        store:['DETGASTSOL']
                    },
                    type:'ComboBox',
                    id_grupo:0,
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Documento",
                        gwidth: 130,
                        inputType:'file',
                        name: 'archivo',
                        buttonText: '',
                        maxLength:150,
                        anchor:'100%'
                    },
                    type:'Field',
                    form:true
                }
            ],
            title:'Subir Detalle Gasto Solicitud',
            fileUpload:true,
            ActSave:'../../sis_adquisiciones/control/SolicitudDet/subirDetalleGastoSolicitud'
        }
    )
</script>