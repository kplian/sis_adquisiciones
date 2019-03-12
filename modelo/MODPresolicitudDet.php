<?php
/**
*@package pXP
*@file gen-MODPresolicitudDet.php
*@author  (admin)
*@date 10-05-2013 05:04:17
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
	ISSUE				FECHA					AUTHOR					DESCRIPCION
 * 	#1					11/12/2018				EGS						Se aumento el campo de precio
 * 	#4					20/02/2019				EGS						Se aumento los campos de num_tramite y id_solicitud
 */

class MODPresolicitudDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPresolicitudDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.ft_presolicitud_det_sel';
		$this->transaccion='ADQ_PRED_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_presolicitud_det','int4');
		$this->captura('descripcion','text');
		$this->captura('cantidad','numeric');
		$this->captura('id_centro_costo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_solicitud_det','int4');
		$this->captura('id_presolicitud','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo_cc','text');
		$this->captura('desc_ingas','varchar');
		$this->captura('precio','numeric');//#1		11/12/2018	EGS	
		$this->captura('num_tramite','varchar');//#4 EGS			
		$this->captura('id_solicitud','int4');//#4 EGS
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPresolicitudDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_presolicitud_det_ime';
		$this->transaccion='ADQ_PRED_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('cantidad_sol','cantidad','numeric');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_solicitud_det','id_solicitud_det','int4');
		$this->setParametro('id_presolicitud','id_presolicitud','int4');
		$this->setParametro('precio','precio','numeric'); //#1		11/12/2018	EGS	
	

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPresolicitudDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_presolicitud_det_ime';
		$this->transaccion='ADQ_PRED_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presolicitud_det','id_presolicitud_det','int4');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('cantidad_sol','cantidad','numeric');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_solicitud_det','id_solicitud_det','int4');
		$this->setParametro('id_presolicitud','id_presolicitud','int4');
		$this->setParametro('precio','precio','numeric');//#1		11/12/2018	EGS	
	

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPresolicitudDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_presolicitud_det_ime';
		$this->transaccion='ADQ_PRED_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_presolicitud_det','id_presolicitud_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>