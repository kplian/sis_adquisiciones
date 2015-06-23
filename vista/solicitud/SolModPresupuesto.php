<?php
/**
*@package pXP
*@file    SolModPresupuesto.php
*@author  Rensi Arteaga Copari 
*@date    30-01-2014
*@description permites subir archivos a la tabla de documento_sol
*/
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
Phx.vista.SolModPresupuesto=Ext.extend(Phx.frmInterfaz,{
    ActSave:'../../sis_adquisiciones/control/Solicitud/SolicitarPresupuesto',

    constructor:function(config)
    {   
        Phx.vista.SolModPresupuesto.superclass.constructor.call(this,config);
        this.init();    
        this.loadValoresIniciales();
        this.obtenerCorreo();
        
        
    },
    
    obtenerCorreo:function(){
       Phx.CP.loadingShow();
       Ext.Ajax.request({
                // form:this.form.getForm().getEl(),
                url:'../../sis_organigrama/control/Funcionario/getEmailEmpresa',
                params:{id_funcionario: this.id_funcionario},
                success:this.successSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
         }); 
        
        
    },
    
    
    successSinc:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(reg.ROOT.datos.resultado!='falla'){
                 if(!reg.ROOT.datos.email_notificaciones_2){
                     
                     alert('Confgure el EMAIL de notificaciones 1, en el archivo de datos generales');
                 }
                
                 this.getComponente('email').setValue(reg.ROOT.datos.email_notificaciones_2);
                 this.getComponente('email_cc').setValue(reg.ROOT.datos.email_empresa);
               
             }else{
                alert(reg.ROOT.datos.mensaje)
            }
     },
    
    loadValoresIniciales:function() 
    {        
        
        var CuerpoCorreo = " <b>SOLICITUD DE TRASPASO PRESUPUESTARIO <br></b><br>" ;
        CuerpoCorreo+= '<b>Funcionario: '+ this.desc_funcionario+'<br></b>';
        CuerpoCorreo+='Tramite: '+ this.num_tramite+'<br>';
        CuerpoCorreo+='Numero: '+this.numero+'</BR>';
        CuerpoCorreo+='<br>Solicitado por: <br> '+Phx.CP.config_ini.nombre_usuario+'<br>';
        CuerpoCorreo+='Se adjunta el solicitud de compra para referencia de los montos </BR>';
         
        Phx.vista.SolModPresupuesto.superclass.loadValoresIniciales.call(this);
        
        

        //this.getComponente('id_cotizacion').setValue(this.id_cotizacion); 
       
        
        this.getComponente('asunto').setValue('ADQ: Solicitud de Presupuesto: '+this.numero); 
        this.getComponente('body').setValue(CuerpoCorreo); 
        
         this.getComponente('id_solicitud').setValue(this.id_solicitud); 
        this.getComponente('estado').setValue(this.estado); 
        
    },
    
    successSave:function(resp)
    {
        Phx.CP.loadingHide();
        Phx.CP.getPagina(this.idContenedorPadre).reload();
        this.panel.close();
    },
                
    
    Atributos:[
   		 /*{
            config:{
                labelSeparator:'',
                inputType:'hidden',
                name: 'id_cotizacion'
            },
            type:'Field',
            form:true
        },*/

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
                labelSeparator:'',
                inputType:'hidden',
                name: 'estado'
            },
            type:'Field',
            form:true
        },
        
             
       
        {
            config:{
                name: 'email',
                fieldLabel: 'Destino',
                allowBlank: true,
                anchor: '90%',
                gwidth: 100,
                maxLength: 100,
                value:'favio@kplian.com',
                readOnly :true
            },
            type:'TextField',
            id_grupo:1,
            form:true
        },
        {
            config:{
                name: 'email_cc',
                fieldLabel: 'CC',
                allowBlank: true,
                anchor: '90%',
                gwidth: 100,
                maxLength: 100,
                readOnly :true
            },
            type:'TextField',
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
             id_grupo:1,
            form:true
        },
         
        
    
    ],
    title:'Solicitud de Compra'
    
   
    
    
})    
</script>