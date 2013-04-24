<?php
/**
*@package pXP
*@file gen-MODCategoriaCompra.php
*@author  (admin)
*@date 06-02-2013 15:59:42
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCategoriaCompra extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCategoriaCompra(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_categoria_compra_sel';
		$this->transaccion='ADQ_CATCOMP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_categoria_compra','int4');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('obs','varchar');
		$this->captura('max','numeric');
		$this->captura('min','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_proceso_macro','int4');
		$this->captura('desc_proceso_macro','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarCategoriaCompra(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_categoria_compra_ime';
		$this->transaccion='ADQ_CATCOMP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('max','max','numeric');
		$this->setParametro('min','min','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCategoriaCompra(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_categoria_compra_ime';
		$this->transaccion='ADQ_CATCOMP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('max','max','numeric');
		$this->setParametro('min','min','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCategoriaCompra(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_categoria_compra_ime';
		$this->transaccion='ADQ_CATCOMP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>