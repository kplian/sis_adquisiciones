<?php
/**
*@package pXP
*@file gen-MODRpc.php
*@author  (admin)
*@date 29-05-2014 15:57:51
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODRpc extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarRpc(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.ft_rpc_sel';
		$this->transaccion='ADQ_RPC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_rpc','int4');
		$this->captura('id_cargo','int4');
		$this->captura('id_cargo_ai','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('ai_habilitado','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_cargo','varchar');
		$this->captura('desc_cargo_suplente','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarRpc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_rpc_ime';
		$this->transaccion='ADQ_RPC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cargo','id_cargo','int4');
		$this->setParametro('id_cargo_ai','id_cargo_ai','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('ai_habilitado','ai_habilitado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarRpc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_rpc_ime';
		$this->transaccion='ADQ_RPC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rpc','id_rpc','int4');
		$this->setParametro('id_cargo','id_cargo','int4');
		$this->setParametro('id_cargo_ai','id_cargo_ai','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('ai_habilitado','ai_habilitado','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarRpc(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_rpc_ime';
		$this->transaccion='ADQ_RPC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rpc','id_rpc','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function clonarRpc(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_rpc_ime';
        $this->transaccion='ADQ_CLONRPC_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_rpc','id_rpc','int4');
        $this->setParametro('id_cargo','id_cargo','int4');
        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('new_fecha_ini','new_fecha_ini','date');
        $this->setParametro('new_fecha_fin','new_fecha_fin','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function changeRpc(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_rpc_ime';
        $this->transaccion='ADQ_CHARPC_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_solicitud','id_solicitud','int4');
        

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    
	
			
}
?>