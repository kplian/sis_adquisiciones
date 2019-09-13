<?php
/**
*@package pXP
*@file gen-MODSolicitud.php
*@author  (admin)
*@date 19-02-2013 12:12:51
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
		* ISSUE            FECHA:		      AUTOR       DESCRIPCION
* 
  		#11 			19/09/2018			EGS			se habilito el campo observacion
 * 		#10 			28/08/2019			EGS			se cambia cantidad integer a numerico
 * */


class MODSolicitud extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarSolicitud(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_solicitud_sel';
		$this->transaccion='ADQ_SOL_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
			
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
		$this->setParametro('tipo_interfaz','tipo_interfaz','varchar');		
		$this->setParametro('historico','historico','varchar');
			
				
		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_solicitud_ext','int4');
		$this->captura('presu_revertido','varchar');
		$this->captura('fecha_apro','date');
		$this->captura('estado','varchar');
		$this->captura('id_funcionario_aprobador','int4');
		$this->captura('id_moneda','int4');
		$this->captura('id_gestion','int4');
		$this->captura('tipo','varchar');
		$this->captura('num_tramite','varchar');
		$this->captura('justificacion','text');
		$this->captura('id_depto','int4');
		$this->captura('lugar_entrega','varchar');
		$this->captura('extendida','varchar');
		
		$this->captura('posibles_proveedores','text');
		$this->captura('id_proceso_wf','int4');
		$this->captura('comite_calificacion','text');
		$this->captura('id_categoria_compra','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('fecha_soli','date');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('id_uo','integer');
		
		$this->captura('desc_funcionario','text');
		$this->captura('desc_funcionario_apro','text');
		$this->captura('desc_uo','text');
		$this->captura('desc_gestion','integer');
		$this->captura('desc_moneda','varchar');
		$this->captura('desc_depto','varchar');
		$this->captura('desc_proceso_macro','varchar');
		$this->captura('desc_categoria_compra','varchar');
		$this->captura('id_proceso_macro','integer');
		$this->captura('numero','varchar');
		$this->captura('desc_funcionario_rpc','text');
		$this->captura('obs','text');
		$this->captura('instruc_rpc','varchar');
		$this->captura('desc_proveedor','varchar');
		$this->captura('id_proveedor','integer');
		$this->captura('id_funcionario_supervisor','integer');
		$this->captura('desc_funcionario_supervisor','text');
		$this->captura('ai_habilitado','varchar');
		$this->captura('id_cargo_rpc','integer');
		$this->captura('id_cargo_rpc_ai','integer');
		$this->captura('tipo_concepto','varchar');
		$this->captura('revisado_asistente','varchar');		
		$this->captura('fecha_inicio','date');
		$this->captura('dias_plazo_entrega','integer');
		$this->captura('obs_presupuestos','varchar');
		$this->captura('precontrato','varchar');
		$this->captura('update_enable','varchar');
		$this->captura('codigo_poa','varchar');		
		$this->captura('obs_poa','varchar');
		$this->captura('contador_estados','bigint');
		$this->captura('nro_po','varchar');
		$this->captura('fecha_po','date');
		$this->captura('importe_total','numeric');
		$this->captura('comprometer_87','varchar');//#10 ++
		$this->captura('observacion','text');// #11 			19/09/2018			EGS	
		
		
		  
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	/*
	 *     ***************************************************************************
     *   ISSUE            FECHA:		      AUTOR       DESCRIPCION
     *  #10  ETR      21/02/2018          RAC         se incrementa columna para comproemter al 87 %, comprometer_87
   
	 * 
	 * */        		
	function insertarSolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_ime';
		$this->transaccion='ADQ_SOL_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_solicitud_ext','id_solicitud_ext','int4');
		$this->setParametro('presu_revertido','presu_revertido','varchar');
		$this->setParametro('fecha_apro','fecha_apro','date');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_funcionario_aprobador','id_funcionario_aprobador','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('num_tramite','num_tramite','varchar');
		$this->setParametro('justificacion','justificacion','text');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('lugar_entrega','lugar_entrega','varchar');
		$this->setParametro('extendida','extendida','varchar');
		$this->setParametro('numero','numero','varchar');
		$this->setParametro('posibles_proveedores','posibles_proveedores','text');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('comite_calificacion','comite_calificacion','text');
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('fecha_soli','fecha_soli','date');		
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');		
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('id_funcionario_supervisor','id_funcionario_supervisor','int4');
		$this->setParametro('tipo_concepto','tipo_concepto','varchar');		
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('dias_plazo_entrega','dias_plazo_entrega','integer');
		$this->setParametro('precontrato','precontrato','varchar');
		$this->setParametro('codigo_poa','codigo_poa','varchar');		
		$this->setParametro('obs_poa','obs_poa','varchar');      
		$this->setParametro('nro_po','nro_po','varchar');
		$this->setParametro('fecha_po','fecha_po','varchar');
		$this->setParametro('comprometer_87','comprometer_87','varchar');//#10 ADQ
		$this->setParametro('observacion','observacion','text');//#11 			19/09/2018			EGS	
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

/*
	 * ***************************************************************************
     *   ISSUE            FECHA:		      AUTOR       DESCRIPCION
     *  #10  ETR      21/02/2018          RAC         se incrementa columna para comproemter al 87 %, comprometer_87
   
	 * 
	 * */  

	function modificarSolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_ime';
		$this->transaccion='ADQ_SOL_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_solicitud_ext','id_solicitud_ext','int4');
		$this->setParametro('presu_revertido','presu_revertido','varchar');
		$this->setParametro('fecha_apro','fecha_apro','date');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('id_funcionario_aprobador','id_funcionario_aprobador','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('num_tramite','num_tramite','varchar');
		$this->setParametro('justificacion','justificacion','text');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('lugar_entrega','lugar_entrega','varchar');
		$this->setParametro('extendida','extendida','varchar');
		$this->setParametro('numero','numero','varchar');
		$this->setParametro('posibles_proveedores','posibles_proveedores','text');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('comite_calificacion','comite_calificacion','text');
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('fecha_soli','fecha_soli','date');		
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('id_funcionario_supervisor','id_funcionario_supervisor','int4');
		$this->setParametro('tipo_concepto','tipo_concepto','varchar');		
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('dias_plazo_entrega','dias_plazo_entrega','integer');
		$this->setParametro('precontrato','precontrato','varchar');
		$this->setParametro('nro_po','nro_po','varchar');
		$this->setParametro('fecha_po','fecha_po','date');
		$this->setParametro('comprometer_87','comprometer_87','varchar');//#10 ADQ
		$this->setParametro('observacion','observacion','text');//#11 			19/09/2018			EGS	
		

		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarSolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_ime';
		$this->transaccion='ADQ_SOL_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud','id_solicitud','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function modificarObsPresupuestos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_ime';
		$this->transaccion='ADQ_MODOBS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('obs','obs','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function modificarObsPoa(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_ime';
		$this->transaccion='ADQ_MODOBSPOA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('obs_poa','obs_poa','varchar');
		$this->setParametro('codigo_poa','codigo_poa','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	


	
	function marcarRevisadoSol(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_ime';
		$this->transaccion='ADQ_REVSOL_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud','id_solicitud','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function finalizarSolicitud(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_solicitud_ime';
        $this->transaccion='ADQ_FINSOL_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_solicitud','id_solicitud','int4');
        $this->setParametro('id_funcionario_rpc','id_funcionario_rpc','int4');
        $this->setParametro('operacion','operacion','varchar');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		
		

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function siguienteEstadoSolicitud(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_solicitud_ime';
        $this->transaccion='ADQ_SIGESOL_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_solicitud','id_solicitud','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        
        
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('operacion','operacion','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('instruc_rpc','instruc_rpc','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function siguienteEstadoSolicitudWzd(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_solicitud_ime';
        $this->transaccion='ADQ_SIGESOLWZD_IME';
        $this->tipo_procedimiento='IME';
        
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
		$this->setParametro('id_depto_lb','id_depto_lb','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
        $this->setParametro('instruc_rpc','instruc_rpc','varchar');
        $this->setParametro('lista_comision','lista_comision','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function verficarSigEstSolWf(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_solicitud_ime';
        $this->transaccion='ADQ_VERSIGPRO_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('operacion','operacion','varchar');
        
       //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function anteriorEstadoSolicitud(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_solicitud_ime';
        $this->transaccion='ADQ_ANTESOL_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_solicitud','id_solicitud','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('operacion','operacion','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
          $this->setParametro('obs','obs','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
	function reporteSolicitud(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_solicitud_sel';
		$this->transaccion='ADQ_SOLREP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		
		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_solicitud_ext','int4');
		$this->captura('presu_revertido','varchar');
		$this->captura('fecha_apro','date');
		$this->captura('estado','varchar');
		$this->captura('id_funcionario_aprobador','int4');
		$this->captura('id_moneda','int4');
		$this->captura('id_gestion','int4');
		$this->captura('tipo','varchar');
		$this->captura('num_tramite','varchar');
		$this->captura('justificacion','text');
		$this->captura('id_depto','int4');
		$this->captura('lugar_entrega','varchar');
		$this->captura('extendida','varchar');
		
		$this->captura('posibles_proveedores','text');
		$this->captura('id_proceso_wf','int4');
		$this->captura('comite_calificacion','text');
		$this->captura('id_categoria_compra','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('fecha_soli','date');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_uo','integer');
		$this->captura('desc_funcionario','text');
		
		$this->captura('desc_funcionario_apro','text');
		$this->captura('desc_uo','text');
		$this->captura('desc_gestion','integer');
		$this->captura('desc_moneda','varchar');
		$this->captura('desc_depto','varchar');
		$this->captura('desc_proceso_macro','varchar');
		$this->captura('desc_categoria_compra','varchar');
		$this->captura('id_proceso_macro','integer');
		$this->captura('numero','varchar');
		$this->captura('desc_funcionario_rpc','text');
		$this->captura('nombre_usuario_ai','varchar');
		$this->captura('codigo_uo','varchar');
		$this->captura('presu_comprometido','varchar');
		
		
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		return $this->respuesta;
	}
	
	function reportePreOrdenCompra(){
		//Definicion de variables para ejecucion del procedimientp
				
		$this->procedimiento='adq.f_solicitud_sel';
		$this->transaccion='ADQ_SOLOC_REP';
		$this->tipo_procedimiento='SEL';
		$this->setCount(false);
		
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->captura('desc_proveedor','varchar');
		$this->captura('id_persona','int4');
		$this->captura('dir_persona','varchar');
		$this->captura('telf1_persona','varchar');
		$this->captura('telf2_persona','varchar');
		$this->captura('cel_persona','varchar');
		$this->captura('correo_persona','varchar');
		$this->captura('id_institucion','int4');
		$this->captura('dir_institucion','varchar');
		$this->captura('telf1_institucion','varchar');
		$this->captura('telf2_institucion','varchar');
		$this->captura('cel_institucion','varchar');
		$this->captura('email_institucion','varchar');
		$this->captura('fax_institucion','varchar');
		$this->captura('lugar_entrega','varchar');
		$this->captura('tipo','varchar');
		$this->captura('moneda','varchar');
		$this->captura('codigo_moneda','varchar');
		$this->captura('num_tramite','varchar');
				
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->respuesta); exit;
		return $this->respuesta;
	}
	
	function estadosSolicitud(){
		$this->procedimiento = 'adq.f_solicitud_sel';
		$this->transaccion = 'ADQ_ESTSOL_SEL';
		$this->tipo_procedimiento = 'SEL';
		$this->setCount(false);
		
		$this->setParametro('id_solicitud','id_solicitud','int4');
		
		$this->captura('funcionario','text');
		$this->captura('nombre','text');
		$this->captura('nombre_estado','varchar');
		$this->captura('fecha_reg','date');
		$this->captura('id_tipo_estado','int');
		$this->captura('id_estado_wf','int');
		$this->captura('id_estado_anterior','int');		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}	
	
	function estadosProceso(){
		$this->procedimiento = 'adq.f_solicitud_sel';
		$this->transaccion = 'ADQ_ESTPROC_SEL';
		$this->tipo_procedimiento = 'SEL';
		$this->setCount(false);
		
		$this->setParametro('id_proceso_compra','id_proceso_compra','int4');
		
		$this->captura('funcionario','text');
		$this->captura('nombre','text');
		$this->captura('nombre_estado','varchar');
		$this->captura('fecha_reg','date');
		$this->captura('id_tipo_estado','int');
		$this->captura('id_estado_wf','int');
		$this->captura('id_estado_anterior','int');		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}

     
        		
	function insertarSolicitudCompleta(){
		
		
		
		
		//Abre conexion con PDO
		$cone = new conexion();
		$link = $cone->conectarpdo();
		$copiado = false;			
		try {
			$link->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);		
		  	$link->beginTransaction();
			
			/////////////////////////
			//  inserta cabecera de la solicitud de compra
			///////////////////////
			
			//Definicion de variables para ejecucion del procedimiento
			$this->procedimiento = 'adq.f_solicitud_ime';
			$this->transaccion = 'ADQ_SOL_INS';
			$this->tipo_procedimiento = 'IME';
			
			//Define los parametros para la funcion
			$this->setParametro('estado_reg','estado_reg','varchar');
			$this->setParametro('id_solicitud_ext','id_solicitud_ext','int4');
			$this->setParametro('presu_revertido','presu_revertido','varchar');
			$this->setParametro('fecha_apro','fecha_apro','date');
			$this->setParametro('estado','estado','varchar');		
			$this->setParametro('id_moneda','id_moneda','int4');
			$this->setParametro('id_gestion','id_gestion','int4');
			$this->setParametro('tipo','tipo','varchar');
			$this->setParametro('num_tramite','num_tramite','varchar');
			$this->setParametro('justificacion','justificacion','text');
			$this->setParametro('id_depto','id_depto','int4');
			$this->setParametro('lugar_entrega','lugar_entrega','varchar');
			$this->setParametro('extendida','extendida','varchar');
			$this->setParametro('numero','numero','varchar');
			$this->setParametro('posibles_proveedores','posibles_proveedores','text');
			$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
			$this->setParametro('comite_calificacion','comite_calificacion','text');
			$this->setParametro('id_categoria_compra','id_categoria_compra','int4');
			$this->setParametro('id_funcionario','id_funcionario','int4');
			$this->setParametro('id_estado_wf','id_estado_wf','int4');
			$this->setParametro('fecha_soli','fecha_soli','date');
			$this->setParametro('id_proceso_macro','id_proceso_macro','int4');
			$this->setParametro('id_proveedor','id_proveedor','int4');
			$this->setParametro('tipo_concepto','tipo_concepto','varchar');
			$this->setParametro('fecha_inicio','fecha_inicio','date');
			$this->setParametro('dias_plazo_entrega','dias_plazo_entrega','integer');
			$this->setParametro('precontrato','precontrato','varchar');
			$this->setParametro('correo_proveedor','correo_proveedor','varchar');
			$this->setParametro('nro_po','nro_po','varchar');
			$this->setParametro('fecha_po','fecha_po','date');
			$this->setParametro('observacion','observacion','varchar');
			$this->setParametro('comprometer_87','comprometer_87','varchar');//#10 ADQ

			//Ejecuta la instruccion
            $this->armarConsulta();
			$stmt = $link->prepare($this->consulta);		  
		  	$stmt->execute();
			$result = $stmt->fetch(PDO::FETCH_ASSOC);				
			
			//recupera parametros devuelto depues de insertar ... (id_solicitud)
			$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
			if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
				throw new Exception("Error al ejecutar en la bd", 3);
			}
			
			$respuesta = $resp_procedimiento['datos'];
			
			$id_solicitud = $respuesta['id_solicitud'];
			
			//////////////////////////////////////////////
			//inserta detalle de la solicitud de compra
			/////////////////////////////////////////////
			
			
			
			//decodifica JSON  de detalles 
			$json_detalle = $this->aParam->_json_decode($this->aParam->getParametro('json_new_records'));			
			
			//var_dump($json_detalle)	;
			foreach($json_detalle as $f){
				
				$this->resetParametros();
				//Definicion de variables para ejecucion del procedimiento
			    $this->procedimiento='adq.f_solicitud_det_ime';
			    $this->transaccion='ADQ_SOLD_INS';
			    $this->tipo_procedimiento='IME';
				//modifica los valores de las variables que mandaremos
				$this->arreglo['id_centro_costo'] = $f['id_centro_costo'];
				$this->arreglo['descripcion'] = $f['descripcion'];
				$this->arreglo['precio_unitario'] = $f['precio_unitario'];
				$this->arreglo['id_solicitud'] = $id_solicitud;
				$this->arreglo['id_orden_trabajo'] = $f['id_orden_trabajo'];
				$this->arreglo['id_concepto_ingas'] = $f['id_concepto_ingas'];
				$this->arreglo['precio_total'] = $f['precio_total'];
				$this->arreglo['cantidad_sol'] = $f['cantidad_sol'];
				$this->arreglo['precio_ga'] = $f['precio_ga'];
				$this->arreglo['precio_sg'] = $f['precio_sg'];
				
				//Define los parametros para la funcion
				$this->setParametro('id_centro_costo', 'id_centro_costo', 'int4');
				$this->setParametro('descripcion', 'descripcion', 'text');
				$this->setParametro('precio_unitario', 'precio_unitario', 'numeric');
				$this->setParametro('id_solicitud', 'id_solicitud', 'int4');
				$this->setParametro('id_orden_trabajo', 'id_orden_trabajo', 'int4');
				$this->setParametro('id_concepto_ingas', 'id_concepto_ingas', 'int4');
				$this->setParametro('precio_total', 'precio_total', 'numeric');
				$this->setParametro('cantidad_sol', 'cantidad_sol', 'numeric'); //#10
				$this->setParametro('precio_ga', 'precio_ga', 'numeric');
				$this->setParametro('precio_sg', 'precio_sg', 'numeric');
				
				//Ejecuta la instruccion
	            $this->armarConsulta();
				$stmt = $link->prepare($this->consulta);		  
			  	$stmt->execute();
				$result = $stmt->fetch(PDO::FETCH_ASSOC);				
				
				//recupera parametros devuelto depues de insertar ... (id_solicitud)
				$resp_procedimiento = $this->divRespuesta($result['f_intermediario_ime']);
				if ($resp_procedimiento['tipo_respuesta']=='ERROR') {
					throw new Exception("Error al insertar detalle  en la bd", 3);
				}
                    
                        
            }
			
			
			
			//si todo va bien confirmamos y regresamos el resultado
			$link->commit();
			$this->respuesta=new Mensaje();
			$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
			$this->respuesta->setDatos($respuesta);
		} 
	    catch (Exception $e) {			
		    	$link->rollBack();
				$this->respuesta=new Mensaje();
				if ($e->getCode() == 3) {//es un error de un procedimiento almacenado de pxp
					$this->respuesta->setMensaje($resp_procedimiento['tipo_respuesta'],$this->nombre_archivo,$resp_procedimiento['mensaje'],$resp_procedimiento['mensaje_tec'],'base',$this->procedimiento,$this->transaccion,$this->tipo_procedimiento,$this->consulta);
				} else if ($e->getCode() == 2) {//es un error en bd de una consulta
					$this->respuesta->setMensaje('ERROR',$this->nombre_archivo,$e->getMessage(),$e->getMessage(),'modelo','','','','');
				} else {//es un error lanzado con throw exception
					throw new Exception($e->getMessage(), 2);
				}
				
		}    
	    
	    return $this->respuesta;
	}

    function reporteCertificadoPoa(){
        //Definicion de variables para ejecucion del procedimientp

        $this->procedimiento='adq.f_solicitud_sel';
        $this->transaccion='ADQ_CERT_SEL';
        $this->tipo_procedimiento='SEL';

        $this->setCount(false);
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        $this->captura('id_solicitud','int4');
        $this->captura('num_tramite','varchar');
        $this->captura('fecha_soli','text');
        $this->captura('justificacion','text');
        $this->captura('codigo_poa','varchar');
        $this->captura('codigo_descripcion','text');
        $this->captura('gestion','int4');

        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta); exit;
        return $this->respuesta;
    }

	function recuperarComite(){
		//Definicion de variables para ejecucion del procedimientp

		$this->procedimiento='adq.f_solicitud_sel';
		$this->transaccion='ADQ_RMEMOCOMDCR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);

		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');

		//Definicion de la lista del resultado del query


		$this->captura('funcionario','text');
		$this->captura('proveedor','varchar');
		$this->captura('tramite','varchar');
		$this->captura('nombres','varchar');
		$this->captura('fecha_po','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		//var_dump($this->consulta);exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarMoneda(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_solicitud_ime';
		$this->transaccion='ADQ_MONEDA_GET';
		$this->tipo_procedimiento='IME';//tipo de transaccion
		$this->setCount(false);

		$this->setParametro('nombre_moneda','nombre_moneda','varchar');

		$this->captura('id_moneda','varchar');
		$this->captura('moneda','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function validarNroPo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_solicitud_ime';
		$this->transaccion='ADQ_NUMPO_GET';
		$this->tipo_procedimiento='IME';//tipo de transaccion
		$this->setCount(false);

		$this->setParametro('nro_po','nro_po','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');

		$this->captura('v_valid','varchar');
		$this->captura('v_id_funcionario','varchar');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	function listarVeriCabecera(){			
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_solicitud_sel';
		$this->transaccion='ADQ_REPVERDISP_SEL';
		$this->tipo_procedimiento='SEL';
		$this->setCount(false);		
		//
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');		
		//Definicion de la lista del resultado del query
		$this->captura('tipo','varchar');
		$this->captura('num_tramite','varchar');
		$this->captura('justificacion','varchar');	
		$this->captura('descripcion','varchar');
		$this->captura('codigo','varchar');
		$this->captura('precio_total','numeric');
		$this->captura('observacion','varchar');
		$this->captura('gestion','int4');
		$this->captura('fecha_soli','date');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();		
		//Devuelve la respuesta

		return $this->respuesta;
	}
//
	function getCertSol(){			
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_solicitud_ime';
		$this->transaccion='ADQ_CERDATA_GET';
		$this->tipo_procedimiento='IME';
		$this->setCount(false);		
		//
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');					
			
		//Definicion de la lista del resultado del query

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();		
		//Devuelve la respuesta

		return $this->respuesta;
	}

			
}
?>