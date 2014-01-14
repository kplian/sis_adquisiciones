<?php
/**
*@package pXP
*@file gen-MODDocumentoSol.php
*@author  (admin)
*@date 08-02-2013 19:01:00
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDocumentoSol extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarDocumentoSol(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='adq.f_documento_sol_sel';
        $this->transaccion='ADQ_DOCSOL_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        
        $this->setParametro('id_solicitud','id_solicitud','int4');      
        //Definicion de la lista del resultado del query
        $this->captura('id_documento_sol','int4');
        $this->captura('id_solicitud','int4');
        $this->captura('id_categoria_compra','int4');
        $this->captura('nombre_doc','varchar');
        $this->captura('nombre_arch_doc','varchar');       
        $this->captura('nombre_tipo_doc','varchar');        
        $this->captura('chequeado','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');        
        
        //Ejecuta la instruccion
        $this->armarConsulta();     
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarDocumentoSolArchivo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='adq.f_documento_sol_sel';
        $this->transaccion='ADQ_DOCSOLAR_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        
        $this->setParametro('id_solicitud','id_solicitud','int4');  
        
        $_SESSION["ARCHIVO"]=array();    
        //Definicion de la lista del resultado del query
        $this->captura('id_documento_sol','int4');
        $this->captura('id_solicitud','int4');
        $this->captura('id_categoria_compra','int4');
        $this->captura('nombre_doc','varchar');
        $this->captura('nombre_arch_doc','varchar');
        $this->captura('archivo','bytea','id_documento_sol','extension','archivo','../../../sis_adquisiciones/archivos_servidor/');
        $this->captura('nombre_tipo_doc','varchar');
        $this->captura('extension','varchar');
        $this->captura('chequeado','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar'); 
        $this->captura('desc_categoria_compra','varchar');
        
        $this->captura('id_proveedor','int4');
        $this->captura('desc_proveedor','varchar');
               
               
        
        //Ejecuta la instruccion
        $this->armarConsulta();     
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function insertarDocumentoSol(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_documento_sol_ime';
        $this->transaccion='ADQ_DOCSOL_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_solicitud','id_solicitud','int4');
        $this->setParametro('id_categoria_compra','id_categoria_compra','int4');
        $this->setParametro('nombre_doc','nombre_doc','varchar');
        $this->setParametro('nombre_arch_doc','nombre_arch_doc','varchar');
        $this->setParametro('nombre_tipo_doc','nombre_tipo_doc','varchar');
        $this->setParametro('chequeado','chequeado','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_proveedor','id_proveedor','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();     
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarDocumentoSol(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_documento_sol_ime';
        $this->transaccion='ADQ_DOCSOL_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_documento_sol','id_documento_sol','int4');
        $this->setParametro('id_solicitud','id_solicitud','int4');
        $this->setParametro('id_categoria_compra','id_categoria_compra','int4');
        $this->setParametro('nombre_doc','nombre_doc','varchar');
        $this->setParametro('nombre_arch_doc','nombre_arch_doc','varchar');
        $this->setParametro('nombre_tipo_doc','nombre_tipo_doc','varchar');
        $this->setParametro('chequeado','chequeado','bool');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_proveedor','id_proveedor','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();     
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarDocumentoSol(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_documento_sol_ime';
        $this->transaccion='ADQ_DOCSOL_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_documento_sol','id_documento_sol','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function subirDocumentoSolArchivo(){
        $this->procedimiento='adq.f_documento_sol_ime';
        $this->transaccion='ADQ_DOCSOLAR_MOD';
        $this->tipo_procedimiento='IME';
        
        $ext = pathinfo($this->arregloFiles['archivo']['name']);
        $this->arreglo['extension']= $ext['extension'];
        
        //Define los parametros para la funcion 
        $this->setParametro('id_documento_sol','id_documento_sol','integer');   
        $this->setParametro('extension','extension','varchar');
        $this->setFile('archivo','id_documento_sol', false, '', array('doc','pdf','docx','jpg','jpeg','bmp','gif','png'));
                
        //Ejecuta la instruccion
        $this->armarConsulta();
                
        $this->ejecutarConsulta();
        return $this->respuesta;
    }
            
}
?>