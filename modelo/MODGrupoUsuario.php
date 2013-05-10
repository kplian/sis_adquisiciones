<?php
/**
*@package pXP
*@file gen-MODGrupoUsuario.php
*@author  (admin)
*@date 09-05-2013 22:46:48
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODGrupoUsuario extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarGrupoUsuario(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.ft_grupo_usuario_sel';
		$this->transaccion='ADQ_GRUS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_grupo_usuario','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario','int4');
		$this->captura('obs','text');
		$this->captura('id_grupo','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_persona','text');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarGrupoUsuario(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_grupo_usuario_ime';
		$this->transaccion='ADQ_GRUS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_usuario','id_usuario','int4');
		$this->setParametro('obs','obs','text');
		$this->setParametro('id_grupo','id_grupo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarGrupoUsuario(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_grupo_usuario_ime';
		$this->transaccion='ADQ_GRUS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_grupo_usuario','id_grupo_usuario','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_usuario','id_usuario','int4');
		$this->setParametro('obs','obs','text');
		$this->setParametro('id_grupo','id_grupo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarGrupoUsuario(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_grupo_usuario_ime';
		$this->transaccion='ADQ_GRUS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_grupo_usuario','id_grupo_usuario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>