<?php
/**
*@package pXP
*@file gen-MODGrupoPartida.php
*@author  (admin)
*@date 09-05-2013 22:46:52
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODGrupoPartida extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarGrupoPartida(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.ft_grupo_partida_sel';
		$this->transaccion='ADQ_GRPA_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_grupo_partida','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_grupo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('nombre_partida','varchar');
		$this->captura('desc_partida','text');
		$this->captura('id_gestion','int4');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarGrupoPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_grupo_partida_ime';
		$this->transaccion='ADQ_GRPA_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_grupo','id_grupo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarGrupoPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_grupo_partida_ime';
		$this->transaccion='ADQ_GRPA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_grupo_partida','id_grupo_partida','int4');
		$this->setParametro('id_partida','id_partida','int4');
		$this->setParametro('id_grupo','id_grupo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarGrupoPartida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.ft_grupo_partida_ime';
		$this->transaccion='ADQ_GRPA_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_grupo_partida','id_grupo_partida','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>