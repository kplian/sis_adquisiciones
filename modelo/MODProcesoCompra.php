<?php
/**
*@package pXP
*@file gen-MODProcesoCompra.php
*@author  (admin)
*@date 19-03-2013 12:55:30
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProcesoCompra extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarProcesoCompra(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_proceso_compra_sel';
		$this->transaccion='ADQ_PROC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_proceso_compra','int4');
		$this->captura('id_depto','int4');
		$this->captura('num_convocatoria','varchar');
		$this->captura('id_solicitud','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('fecha_ini_proc','date');
		$this->captura('obs_proceso','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('num_tramite','varchar');
		$this->captura('codigo_proceso','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('num_cotizacion','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('desc_depto','varchar');
		$this->captura('desc_funcionario','text');
		$this->captura('desc_solicitud','varchar');
		$this->captura('desc_moneda','varchar');
		$this->captura('instruc_rpc','varchar');
		$this->captura('id_categoria_compra','int4');
		$this->captura('usr_aux','varchar');
		$this->captura('id_moneda','integer');
		$this->captura('id_funcionario','integer');
		$this->captura('id_usuario_auxiliar','integer');
		$this->captura('desc_cotizacion','text');
	 
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarProcesoCompraSolicitud(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_proceso_compra_sel';
		$this->transaccion='ADQ_PROCSOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_solicitud','id_solicitud','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_proceso_compra','int4');	 
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
function listarProcesoCompraPedido(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_proceso_compra_sel';
		$this->transaccion='ADQ_PROCPED_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
				
		$this->setParametro('id_proceso_compra','id_proceso_compra','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_proceso_compra','int4');
		$this->captura('id_depto','int4');
		$this->captura('num_convocatoria','varchar');
		$this->captura('id_solicitud','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('fecha_ini_proc','date');
		$this->captura('obs_proceso','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('num_tramite','varchar');
		$this->captura('codigo_proceso','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('num_cotizacion','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('desc_depto','varchar');
		$this->captura('desc_funcionario','text');
		$this->captura('desc_solicitud','varchar');
		$this->captura('desc_moneda','varchar');
		
		
		
		
		 
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	/*
	Asignacion de usuarios al proceso de compra
	
	*/
	function asignarUsuarioProceso(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_proceso_compra_ime';
        $this->transaccion='ADQ_ASIGPROC_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_depto_usuario','id_depto_usuario','int4');
        $this->setParametro('id_solicitud','id_solicitud','int4');
        

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
	function insertarProcesoCompra(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_proceso_compra_ime';
		$this->transaccion='ADQ_PROC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('num_convocatoria','num_convocatoria','varchar');
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('fecha_ini_proc','fecha_ini_proc','date');
		$this->setParametro('obs_proceso','obs_proceso','varchar');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('num_tramite','num_tramite','varchar');
		$this->setParametro('codigo_proceso','codigo_proceso','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('num_cotizacion','num_cotizacion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarProcesoCompra(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_proceso_compra_ime';
		$this->transaccion='ADQ_PROC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proceso_compra','id_proceso_compra','int4');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('num_convocatoria','num_convocatoria','varchar');
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('fecha_ini_proc','fecha_ini_proc','date');
		$this->setParametro('obs_proceso','obs_proceso','varchar');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('num_tramite','num_tramite','varchar');
		$this->setParametro('codigo_proceso','codigo_proceso','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('num_cotizacion','num_cotizacion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarProcesoCompra(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_proceso_compra_ime';
		$this->transaccion='ADQ_PROC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_proceso_compra','id_proceso_compra','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function revertirPresupuesto(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_proceso_compra_ime';
        $this->transaccion='ADQ_REVPRE_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_compra','id_proceso_compra','int4');
        $this->setParametro('id_solicitud','id_solicitud','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function finalizarProceso(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_proceso_compra_ime';
        $this->transaccion='ADQ_FINPRO_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_compra','id_proceso_compra','int4');
        $this->setParametro('id_solicitud','id_solicitud','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
	
	
			
}
?>