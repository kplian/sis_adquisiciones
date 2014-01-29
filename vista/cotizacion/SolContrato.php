<?php
/**
*@package pXP
*@file    SolContrato.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.SolContrato=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_adquisiciones/control/DocumentoSol/subirArchivo',

    constructor:function(config)
    {   
        Phx.vista.SolContrato.superclass.constructor.call(this,config);
        this.init();    
        this.loadValoresIniciales();
        
        console.log(config)
        
    },
    
    loadValoresIniciales:function()
    {        
        Phx.vista.SolContrato.superclass.loadValoresIniciales.call(this);
        this.getComponente('id_cotizacion').setValue(this.id_cotizacion); 
        
        
        
        
            
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
                name: 'id_cotizacion'
            },
            type:'Field',
            form:true
        },
        {
            config:{
                name: 'email',
                fieldLabel: 'Email Remitente',
                allowBlank: true,
                anchor: '90%',
                gwidth: 100,
                maxLength: 100,
                value:'rensi@kplian.com',
                readOnly :true
            },
            type:'TextField',
            filters:{pfiltro:'plcr.remitente_email',type:'string'},
            id_grupo:1,
            form:true
        },      
        {
            config:{
                name: 'asunto',
                fieldLabel: 'Asunto',
                allowBlank: true,
                anchor: '90%',
                gwidth: 100,
                maxLength: 100
            },
            type:'TextField',
            filters:{pfiltro:'plcr.asunto',type:'string'},
            id_grupo:1,
            form:true
        },
        {
            config:{
                name: 'body',
                fieldLabel: 'Mensaje',
                anchor: '90%'
            },
            type:'HtmlEditor',
            filters:{pfiltro:'plcr.body',type:'string'},
            id_grupo:1,
            form:true
        },      
    ],
    title:'SOlicitud de Contrato'
    
}
)    
</script>