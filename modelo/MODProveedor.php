<?php
/**
*@package pXP
*@file MODProveedor.php
*@author  Gonzalo Sarmiento Sejas
*@date 01-03-2013 10:44:58
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProveedor extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarProveedor(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_tproveedor_sel';
		$this->transaccion='ADQ_PROVEE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		$this->setParametro('tipo','tipo','varchar');  		
		//Definicion de la lista del resultado del query
		$this->captura('id_proveedor','int4');		
		$this->captura('id_institucion','int4');
		$this->captura('id_persona','int4');
		$this->captura('tipo','varchar');
		$this->captura('numero_sigma','varchar');
		$this->captura('codigo','varchar');		
		$this->captura('nit','varchar');
		$this->captura('id_lugar','int4');
		
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('nombre_completo1','text');
		$this->captura('nombre','varchar');	
		$this->captura('lugar','varchar');
		$this->captura('nombre_proveedor','varchar');
		$this->captura('rotulo_comercial','varchar');
		$this->captura('ci','varchar');
		$this->captura('desc_dir_proveedor','varchar');
		$this->captura('contacto','text');

        $this->captura('tipo_prov','varchar');
				
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarProveedor(){ 
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_tproveedor_ime';
		$this->transaccion='ADQ_PROVEE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_persona','id_persona','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('numero_sigma','numero_sigma','varchar');
		$this->setParametro('tipo','tipo','varchar');
		//$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_institucion','id_institucion','int4');
		$this->setParametro('doc_id','doc_id','bigint');
		$this->setParametro('nombre_institucion','nombre_institucion','varchar');
		$this->setParametro('direccion_institucion','direccion_institucion','varchar');
		$this->setParametro('casilla','casilla','bigint');
		$this->setParametro('telefono1_institucion','telefono1_institucion','bigint');
		$this->setParametro('telefono2_institucion','telefono2_institucion','bigint');
		$this->setParametro('celular1_institucion','celular1_institucion','bigint');
		$this->setParametro('celular2_institucion','celular2_institucion','bigint');
		$this->setParametro('fax','fax','bigint');
		$this->setParametro('email1_institucion','email1_institucion','varchar');
		$this->setParametro('email2_institucion','email2_institucion','varchar');
		$this->setParametro('pag_web','pag_web','varchar');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('codigo_banco','codigo_banco','varchar');
		$this->setParametro('codigo_institucion','codigo_institucion','varchar');
		
		$this->setParametro('nit','nit','varchar');
		$this->setParametro('id_lugar','id_lugar','int4');
  
		$this->setParametro('register','register','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('apellido_paterno','apellido_paterno','varchar');
		$this->setParametro('apellido_materno','apellido_materno','varchar');
		$this->setParametro('ci','ci','int4');
		$this->setParametro('correo','correo','varchar');
		$this->setParametro('celular1','celular1','varchar');
		$this->setParametro('celular2','celular2','varchar');
		$this->setParametro('telefono1','telefono1','varchar');
		$this->setParametro('telefono2','telefono2','varchar');
		$this->setParametro('genero','genero','varchar');
		$this->setParametro('fecha_nacimiento','fecha_nacimiento','date');
		$this->setParametro('direccion','direccion','varchar');
		$this->setParametro('rotulo_comercial','rotulo_comercial','varchar');
		$this->setParametro('contacto','contacto','text');

        $this->setParametro('tipo_prov','tipo_prov','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
		
		
	}
			
	function modificarProveedor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_tproveedor_ime';
		$this->transaccion='ADQ_PROVEE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('id_persona','id_persona','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('numero_sigma','numero_sigma','varchar');
		$this->setParametro('tipo','tipo','varchar');		
		$this->setParametro('id_institucion','id_institucion','int4');
		$this->setParametro('doc_id','doc_id','int4');
		$this->setParametro('nombre_institucion','nombre_institucion','varchar');
		$this->setParametro('direccion_institucion','direccion_institucion','varchar');
		$this->setParametro('casilla','casilla','bigint');
		$this->setParametro('telefono1_institucion','telefono1_institucion','bigint');
		$this->setParametro('telefono2_institucion','telefono2_institucion','bigint');
		$this->setParametro('celular1_institucion','celular1_institucion','bigint');
		$this->setParametro('celular2_institucion','celular2_institucion','bigint');
		$this->setParametro('fax','fax','bigint');
		$this->setParametro('email1_institucion','email1_institucion','varchar');
		$this->setParametro('email2_institucion','email2_institucion','varchar');
		$this->setParametro('pag_web','pag_web','varchar');
		$this->setParametro('observaciones','observaciones','varchar');
		$this->setParametro('codigo_banco','codigo_banco','varchar');
		$this->setParametro('codigo_institucion','codigo_institucion','varchar');
		
		$this->setParametro('nit','nit','varchar');
		$this->setParametro('id_lugar','id_lugar','int4');
  
		$this->setParametro('register','register','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('apellido_paterno','apellido_paterno','varchar');
		$this->setParametro('apellido_materno','apellido_materno','varchar');
		$this->setParametro('ci','ci','int4');
		$this->setParametro('correo','correo','varchar');
		$this->setParametro('celular1','celular1','bigint');
		$this->setParametro('celular2','celular2','bigint');
		$this->setParametro('telefono1','telefono1','bigint');
		$this->setParametro('telefono2','telefono2','bigint');
		$this->setParametro('genero','genero','varchar');
		$this->setParametro('fecha_nacimiento','fecha_nacimiento','date');
		$this->setParametro('direccion','direccion','varchar');
		$this->setParametro('rotulo_comercial','rotulo_comercial','varchar');
		$this->setParametro('contacto','contacto','text');

		$this->setParametro('tipo_prov','tipo_prov','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarProveedor(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_tproveedor_ime';
		$this->transaccion='ADQ_PROVEE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proveedor','id_proveedor','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>
