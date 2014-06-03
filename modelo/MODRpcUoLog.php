<?php
/**
*@package pXP
*@file gen-MODRpcUoLog.php
*@author  (admin)
*@date 03-06-2014 13:14:39
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODRpcUoLog extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarRpcUoLog(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.ft_rpc_uo_log_sel';
		$this->transaccion='ADQ_RPCL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_rpc_uo_log','int4');
		$this->captura('monto_max','numeric');
		$this->captura('id_rpc_uo','int4');
		$this->captura('id_categoria_compra','int4');
		$this->captura('operacion','varchar');
		$this->captura('fecha_ini','date');
		$this->captura('descripcion','text');
		$this->captura('fecha_fin','date');
		$this->captura('id_rpc','int4');
		$this->captura('id_cargo','int4');
		$this->captura('id_cargo_ai','int4');
		$this->captura('id_uo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('ai_habilitado','varchar');
		$this->captura('monto_min','numeric');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_cargo','varchar');
		$this->captura('desc_cargo_ai','varchar');
		$this->captura('desc_uo','varchar');
		$this->captura('desc_categoria_compra','varchar');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarRpcUoLog(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_rpc_uo_log_ime';
		$this->transaccion='ADQ_RPCL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('monto_max','monto_max','numeric');
		$this->setParametro('id_rpc_uo','id_rpc_uo','int4');
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');
		$this->setParametro('operacion','operacion','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('id_rpc','id_rpc','int4');
		$this->setParametro('id_cargo','id_cargo','int4');
		$this->setParametro('id_cargo_ai','id_cargo_ai','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('ai_habilitado','ai_habilitado','varchar');
		$this->setParametro('monto_min','monto_min','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarRpcUoLog(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_rpc_uo_log_ime';
		$this->transaccion='ADQ_RPCL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rpc_uo_log','id_rpc_uo_log','int4');
		$this->setParametro('monto_max','monto_max','numeric');
		$this->setParametro('id_rpc_uo','id_rpc_uo','int4');
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');
		$this->setParametro('operacion','operacion','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('id_rpc','id_rpc','int4');
		$this->setParametro('id_cargo','id_cargo','int4');
		$this->setParametro('id_cargo_ai','id_cargo_ai','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('ai_habilitado','ai_habilitado','varchar');
		$this->setParametro('monto_min','monto_min','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarRpcUoLog(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_rpc_uo_log_ime';
		$this->transaccion='ADQ_RPCL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rpc_uo_log','id_rpc_uo_log','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>