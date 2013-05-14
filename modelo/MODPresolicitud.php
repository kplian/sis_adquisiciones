<?php
/**
*@package pXP
*@file gen-MODPresolicitud.php
*@author  (admin)
*@date 10-05-2013 05:03:41
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPresolicitud extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPresolicitud(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.ft_presolicitud_sel';
		$this->transaccion='ADQ_PRES_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_presolicitud','int4');
		$this->captura('id_grupo','int4');
		$this->captura('id_funcionario_supervisor','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('obs','text');
		$this->captura('id_uo','int4');
		$this->captura('estado','varchar');
		$this->captura('id_solicitudes','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_grupo','varchar');
		$this->captura('desc_funcionario','text');
		$this->captura('desc_funcionario_supervisor','text');
		$this->captura('desc_uo','text');
		$this->captura('fecha_soli','date');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPresolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_presolicitud_ime';
		$this->transaccion='ADQ_PRES_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_grupo','id_grupo','int4');
		$this->setParametro('id_funcionario_supervisor','id_funcionario_supervisor','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('obs','obs','text');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('fecha_soli','fecha_soli','date');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPresolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_presolicitud_ime';
		$this->transaccion='ADQ_PRES_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presolicitud','id_presolicitud','int4');
		$this->setParametro('id_grupo','id_grupo','int4');
		$this->setParametro('id_funcionario_supervisor','id_funcionario_supervisor','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('obs','obs','text');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('fecha_soli','fecha_soli','date');
        

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPresolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_presolicitud_ime';
		$this->transaccion='ADQ_PRES_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presolicitud','id_presolicitud','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>