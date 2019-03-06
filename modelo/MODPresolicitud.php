<?php
/**
*@package pXP
*@file gen-MODPresolicitud.php
*@author  (admin)
*@date 10-05-2013 05:03:41
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
	ISSUE		FECHA:	         AUTOR:				 DESCRIPCION:	
 * #4 endeETR  	19/02/2019       EGS                 -Se elimino transsaciones antiguas del flujo antiguo y se implento el nuevo flujo WF
                                                 	- se implemento  desconsolidar items  
 * */

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
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
		
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
		$this->captura('id_partidas','varchar');
		$this->captura('id_depto','int4');
		$this->captura('desc_depto','text');
		$this->captura('id_gestion','int4');
		$this->captura('asignado','varchar');
		$this->captura('id_proceso_wf','integer');
		$this->captura('id_estado_wf','integer');
		$this->captura('nro_tramite','varchar');
		
		
		
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
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		
		
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
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
        
        

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

     function consolidarSolicitud(){//#4 EGS
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_presolicitud_ime';
        $this->transaccion='ADQ_CONSOL_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_presolicitud','id_presolicitud','int4');
        $this->setParametro('id_solicitud','id_solicitud','int4');
        $this->setParametro('id_presolicitud_dets','id_presolicitud_dets','varchar');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

  function reportePresolicitud(){
					//Definicion de variables para ejecucion del procedimientp
					$this->procedimiento='adq.ft_presolicitud_sel';
					$this->transaccion='ADQ_PRESREP_SEL';
					$this->tipo_procedimiento='SEL';//tipo de transaccion
					
					$this->setParametro('id_presolicitud','id_presolicitud','int4');
							
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
					$this->captura('id_partidas','varchar');					
					
					//Ejecuta la instruccion
					$this->armarConsulta();
					$this->ejecutarConsulta();
					
					//Devuelve la respuesta
					return $this->respuesta;
	}
     function desconsolidarSolicitud(){//#4 EGS
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_presolicitud_ime';
        $this->transaccion='ADQ_DESCONSOL_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_presolicitud','id_presolicitud','int4');
        $this->setParametro('id_solicitud','id_solicitud','int4');
        $this->setParametro('id_presolicitud_dets','id_presolicitud_dets','varchar');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	 function siguienteEstado(){//#4 EGS
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'adq.ft_presolicitud_ime';
        $this->transaccion = 'ADQ_SIGEPRESOL_INS';
        $this->tipo_procedimiento = 'IME';
   
        //Define los parametros para la funcion
        $this->setParametro('id_presolicitud','id_presolicitud','int4');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');		
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        $this->setParametro('id_depto_lb','id_depto_lb','int4');
		$this->setParametro('id_cuenta_bancaria','id_cuenta_bancaria','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }

	
    function anteriorEstado(){//#4 EGS
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.ft_presolicitud_ime';
        $this->transaccion='ADQ_ANTEPRESOL_IME';
        $this->tipo_procedimiento='IME';                
        //Define los parametros para la funcion
         $this->setParametro('id_presolicitud','id_presolicitud','int4');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_destino','estado_destino','varchar');		
		//Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	 

			
}
?>