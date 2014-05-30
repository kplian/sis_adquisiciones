<?php
/**
*@package pXP
*@file gen-MODRpcUo.php
*@author  (admin)
*@date 29-05-2014 15:58:17
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODRpcUo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarRpcUo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.ft_rpc_uo_sel';
		$this->transaccion='ADQ_RUO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_rpc_uo','int4');
		$this->captura('id_rpc','int4');
		$this->captura('id_uo','int4');
		$this->captura('monto_max','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_fin','date');
		$this->captura('fecha_ini','date');
		$this->captura('monto_min','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_uo','varchar');
		$this->captura('id_categoria_compra','integer');
		$this->captura('desc_categoria_compra','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarRpcUo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_rpc_uo_ime';
		$this->transaccion='ADQ_RUO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rpc','id_rpc','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_uos','id_uos','varchar');
		$this->setParametro('monto_max','monto_max','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('monto_min','monto_min','numeric');
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarRpcUo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_rpc_uo_ime';
		$this->transaccion='ADQ_RUO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rpc_uo','id_rpc_uo','int4');
		$this->setParametro('id_rpc','id_rpc','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('monto_max','monto_max','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('monto_min','monto_min','numeric');
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarRpcUo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_rpc_uo_ime';
		$this->transaccion='ADQ_RUO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_rpc_uo','id_rpc_uo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>