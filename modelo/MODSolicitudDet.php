<?php
/**
*@package pXP
*@file gen-MODSolicitudDet.php
*@author  (admin)
*@date 05-03-2013 01:28:10
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
	ISSUE		FECHA		AUTHOR			DESCRIPCION
	#10		28/08/2019	EGS			Modificacion de cantidad de integer a numerico
*/

class MODSolicitudDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarSolicitudDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_solicitud_det_sel';
		$this->transaccion='ADQ_SOLD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_solicitud','id_solicitud','int4');	
		
		//captura parametros adicionales para el count
		$this->capturaCount('precio_total','numeric');
		
		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud_det','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('descripcion','text');
		$this->captura('precio_unitario','numeric');
		$this->captura('id_solicitud','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('precio_sg','numeric');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('precio_total','numeric');
		$this->captura('cantidad','numeric');//#10 EGS
		$this->captura('id_auxiliar','int4');
		$this->captura('precio_ga_mb','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('disponible','varchar');
		$this->captura('precio_ga','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('desc_centro_costo','text');
        $this->captura('codigo_partida','varchar');
        $this->captura('nombre_partida','varchar');
        $this->captura('nro_cuenta','varchar');
        $this->captura('nombre_cuenta','varchar');
        $this->captura('codigo_auxiliar','varchar');
        $this->captura('nombre_auxiliar','varchar');
        $this->captura('desc_concepto_ingas','varchar');
        
        $this->captura('desc_orden_trabajo','varchar');
         
        $this->captura('revertido_mb','numeric');
        $this->captura('revertido_mo','numeric');
        
        $this->captura('id_presupuesto','integer');
		
		$this->captura('id_categoria_prog','integer');
		$this->captura('codigo_categoria','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarSolicitudDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_det_ime';
		$this->transaccion='ADQ_SOLD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('precio_sg','precio_sg','numeric');
		$this->setParametro('precio_ga','precio_ga','numeric');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('precio_total','precio_total','numeric');
		$this->setParametro('cantidad_sol','cantidad','numeric');//#10 EGS
		$this->setParametro('estado_reg','estado_reg','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarDetalleGastoSolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_det_ime';
		$this->transaccion='ADQ_DGSTSOL_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('concepto_gasto','concepto_gasto','varchar');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('centro_costo','centro_costo','varchar');
		$this->setParametro('orden_trabajo','orden_trabajo','varchar');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('cantidad_sol','cantidad_sol','numeric');//#10 EGS
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('precio_total','precio_total','numeric');
		$this->setParametro('precio_sg','precio_sg','numeric');
		$this->setParametro('precio_ga','precio_ga','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarDetalleGastoSolicitud(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_det_ime';
		$this->transaccion='ADQ_DGSTSOL_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_solicitud','id_solicitud','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarSolicitudDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_det_ime';
		$this->transaccion='ADQ_SOLD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud_det','id_solicitud_det','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
        $this->setParametro('descripcion','descripcion','text');
        $this->setParametro('precio_unitario','precio_unitario','numeric');
        $this->setParametro('id_solicitud','id_solicitud','int4');
        $this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
        $this->setParametro('precio_sg','precio_sg','numeric');
        $this->setParametro('precio_ga','precio_ga','numeric');
        $this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
        $this->setParametro('precio_total','precio_total','numeric');
        $this->setParametro('cantidad_sol','cantidad','numeric');//#10 EGS
        $this->setParametro('estado_reg','estado_reg','varchar');
        

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarSolicitudDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_det_ime';
		$this->transaccion='ADQ_SOLD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_solicitud_det','id_solicitud_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarSolicitudDetCotizacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_solicitud_det_sel';
		$this->transaccion='ADQ_SOLDETCOT_SEL';
		$this->tipo_procedimiento='SEL';
		
		
		//Define los parametros para la funcion
		$this->setParametro('id_cotizacion','id_cotizacion','int4');
		$this->captura('id_solicitud_det','int4');
		$this->captura('descripcion','text');
		$this->captura('desc_centro_costo','text');
		$this->captura('desc_concepto_ingas','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function reportePreOrdenCompra(){
		$this->procedimiento='adq.f_solicitud_det_sel';
		$this->transaccion='ADQ_SOLDETOC_REP';
		$this->tipo_procedimiento='SEL';
		$this->setCount(false);
		
		$this->setParametro('id_solicitud','id_solicitud','int4');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->captura('desc_ingas','varchar');
		$this->captura('desc_centro_costo','text');
		$this->captura('cantidad_sol','numeric');//#10 EGS
		$this->captura('precio_unitario_sol','numeric');
		$this->captura('descripcion_sol','text');
		$this->captura('precio_unitario_mb_sol','numeric');
		$this->captura('revertido_mb','numeric');
		$this->captura('revertido_mo','numeric');
				
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->respuesta); exit;
		return $this->respuesta;
	}	
	
	function listarSolicitudDetReporte(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_solicitud_det_sel';
		$this->transaccion='ADQ_SOLDREP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setCount(false);
		
		$this->setParametro('id_solicitud','id_solicitud','int4');	
		
		//Definicion de la lista del resultado del query
		$this->captura('id_solicitud_det','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('descripcion','text');
		$this->captura('precio_unitario','numeric');
		$this->captura('id_solicitud','int4');
		$this->captura('id_partida','int4');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('precio_sg','numeric');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('id_cuenta','int4');
		$this->captura('precio_total','numeric');
		$this->captura('cantidad','numeric');//#10 EGS
		$this->captura('id_auxiliar','int4');
		$this->captura('precio_ga_mb','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_partida_ejecucion','int4');
		$this->captura('disponible','varchar');
		$this->captura('precio_ga','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');		
		$this->captura('desc_centro_costo','text');
        $this->captura('codigo_partida','varchar');
        $this->captura('nombre_partida','varchar');
        $this->captura('nro_cuenta','varchar');
        $this->captura('nombre_cuenta','varchar');
        $this->captura('codigo_auxiliar','varchar');
        $this->captura('nombre_auxiliar','varchar');
        $this->captura('desc_concepto_ingas','varchar');        
        $this->captura('desc_orden_trabajo','varchar');         
        $this->captura('revertido_mb','numeric');
        $this->captura('revertido_mo','numeric');        
        $this->captura('id_presupuesto','integer');		
		$this->captura('id_categoria_prog','integer');
		$this->captura('codigo_categoria','varchar');		
		$this->captura('id_tipo_cc_techo','integer');
		$this->captura('descripcion_techo','varchar');
		$this->captura('control_partida','varchar');
		$this->captura('id_partida_control','integer');
		$this->captura('desc_control_partida','varchar');
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
			
}
?>