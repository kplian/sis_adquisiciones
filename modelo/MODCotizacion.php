<?php
/**
*@package pXP
*@file MODCotizacion.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-03-2013 14:48:35
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCotizacion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCotizacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_cotizacion_sel';
		$this->transaccion='ADQ_COT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		$this->setParametro('id_proceso_compra','id_proceso_compra','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_cotizacion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('lugar_entrega','varchar');
		$this->captura('tipo_entrega','varchar');
		$this->captura('fecha_coti','date');
		$this->captura('numero_oc','varchar');
		$this->captura('id_proveedor','int4');
		$this->captura('desc_proveedor','varchar');
		
		$this->captura('fecha_entrega','date');
		$this->captura('id_moneda','int4');
		$this->captura('moneda','varchar');
		$this->captura('id_proceso_compra','int4');
		$this->captura('fecha_venc','date');
		$this->captura('obs','text');
		$this->captura('fecha_adju','date');
		$this->captura('nro_contrato','varchar');
		
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_estado_wf','integer');
		$this->captura('id_proceso_wf','integer');
		$this->captura('desc_moneda','varchar');
		
		$this->captura('tipo_cambio_conv','numeric');
		
		$this->captura('email','varchar');
				
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	function listarCotizacionProcesoCompra(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_cotizacion_sel';
		$this->transaccion='ADQ_COTPROC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_proceso_compra','id_proceso_compra','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_cotizacion','int4');	 
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarObligacionPagoCotizacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_cotizacion_sel';
		$this->transaccion='ADQ_OBPGCOT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_cotizacion','id_cotizacion','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_obligacion_pago','int4');	 
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function listarCotizacionRPC(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='adq.f_cotizacion_sel';
        $this->transaccion='ADQ_COTRPC_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        $this->setParametro('id_funcionario_rpc','id_funcionario_rpc','int4');
        //Definicion de la lista del resultado del query
        $this->captura('id_cotizacion','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('estado','varchar');
        $this->captura('lugar_entrega','varchar');
        $this->captura('tipo_entrega','varchar');
        $this->captura('fecha_coti','date');
        $this->captura('numero_oc','varchar');
        $this->captura('id_proveedor','int4');
        $this->captura('desc_proveedor','varchar');
        
        $this->captura('fecha_entrega','date');
        $this->captura('id_moneda','int4');
        $this->captura('moneda','varchar');
        $this->captura('id_proceso_compra','int4');
        $this->captura('fecha_venc','date');
        $this->captura('obs','text');
        $this->captura('fecha_adju','date');
        $this->captura('nro_contrato','varchar');
        
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('id_estado_wf','integer');
        $this->captura('id_proceso_wf','integer');
        $this->captura('desc_moneda','varchar');
        
        $this->captura('tipo_cambio_conv','numeric');
        
        $this->captura('id_solicitud','integer');
		$this->captura('id_categoria_compra','integer');
        
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
			
	function insertarCotizacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_cotizacion_ime';
		$this->transaccion='ADQ_COT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		
		$this->setParametro('lugar_entrega','lugar_entrega','varchar');
		$this->setParametro('tipo_entrega','tipo_entrega','varchar');
		$this->setParametro('fecha_coti','fecha_coti','date');
		$this->setParametro('numero_oc','numero_oc','int4');
		$this->setParametro('id_proveedor','id_proveedor','int4');
	
		$this->setParametro('precio_total','precio_total','numeric');
		$this->setParametro('fecha_entrega','fecha_entrega','date');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_proceso_compra','id_proceso_compra','int4');
		$this->setParametro('fecha_venc','fecha_venc','date');
		$this->setParametro('obs','obs','text');
		$this->setParametro('fecha_adju','fecha_adju','date');
		$this->setParametro('nro_contrato','nro_contrato','varchar');
		
		
		$this->setParametro('tipo_cambio_conv','tipo_cambio_conv','numeric');
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCotizacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_cotizacion_ime';
		$this->transaccion='ADQ_COT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cotizacion','id_cotizacion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		
		$this->setParametro('lugar_entrega','lugar_entrega','varchar');
		$this->setParametro('tipo_entrega','tipo_entrega','varchar');
		$this->setParametro('fecha_coti','fecha_coti','date');
		$this->setParametro('numero_oc','numero_oc','int4');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		
		$this->setParametro('precio_total','precio_total','numeric');
		$this->setParametro('fecha_entrega','fecha_entrega','date');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_proceso_compra','id_proceso_compra','int4');
		$this->setParametro('fecha_venc','fecha_venc','date');
		$this->setParametro('obs','obs','text');
		$this->setParametro('fecha_adju','fecha_adju','date');
		$this->setParametro('nro_contrato','nro_contrato','varchar');
		
		
		
        $this->setParametro('tipo_cambio_conv','tipo_cambio_conv','numeric');
        

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCotizacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_cotizacion_ime';
		$this->transaccion='ADQ_COT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cotizacion','id_cotizacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function obtnerUosEpsDetalleAdjudicado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_OBEPUO_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
	

	function reporteCotizacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_cotizacion_sel';
		$this->transaccion='ADQ_COTREP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_cotizacion','id_cotizacion','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('estado','varchar');
		$this->captura('fecha_adju','date');
		$this->captura('fecha_coti','date');
		$this->captura('fecha_entrega','date');
		$this->captura('fecha_venc','date');
		$this->captura('id_moneda','int4');
		$this->captura('moneda','varchar');
		$this->captura('id_proceso_compra','int4');
		$this->captura('codigo_proceso','varchar');
		$this->captura('num_cotizacion','varchar');
		$this->captura('num_tramite','varchar');
		$this->captura('id_proveedor','int4');
		$this->captura('desc_proveedor','varchar');
		$this->captura('id_persona','int4');
		$this->captura('id_institucion','int4');
		$this->captura('dir_per', 'varchar');
		$this->captura('tel_per1', 'varchar');
		$this->captura('tel_per2', 'varchar');
		$this->captura('cel_per','varchar');
		$this->captura('correo','varchar');
		$this->captura('nombre_ins','varchar');
		$this->captura('cel_ins','varchar');
		$this->captura('dir_ins','varchar');
		$this->captura('fax','varchar');
		$this->captura('email_ins','varchar');
		$this->captura('tel_ins1','varchar');
		$this->captura('tel_ins2','varchar');		
		$this->captura('lugar_entrega','varchar');
		$this->captura('nro_contrato','varchar');		
		$this->captura('numero_oc','varchar');
		$this->captura('obs','text');
		$this->captura('tipo_entrega','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function finalizarRegistro(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_FINREGC_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function adjudicarTodo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_ADJTODO_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    
    
   function solicitarAprobacion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_SOLAPRO_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');
       

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
      function generarOC(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_GENOC_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');
        $this->setParametro('fecha_oc','fecha_oc','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
  
  function reporteOrdenCompra(){
		$this->procedimiento='adq.f_cotizacion_sel';
		$this->transaccion='ADQ_COTOC_REP';
		$this->tipo_procedimiento='SEL';
		
		$this->setParametro('id_cotizacion','id_cotizacion','int4');
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
		$this->captura('fecha_entrega','date');
		$this->captura('lugar_entrega','varchar');
		$this->captura('numero_oc','varchar');
		$this->captura('tipo_entrega','varchar');
		$this->captura('id_proceso_compra','int4');
		$this->captura('tipo','varchar');
		$this->captura('fecha_oc','date');
		$this->captura('moneda','varchar');
		
		$this->armarConsulta();
		$this->ejecutarConsulta();
		return $this->respuesta;
	}
    
    function anteriorEstadoCotizacion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_ANTEST_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');
        $this->setParametro('operacion','operacion','varchar');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
     function habilitarPago(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_HABPAG_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');
        $this->setParametro('id_depto_tes','id_depto_tes','int4');
    

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function estadosCotizacion(){
					$this->procedimiento = 'adq.f_cotizacion_sel';
					$this->transaccion = 'ADQ_ESTCOT_SEL';
					$this->tipo_procedimiento = 'SEL';
					$this->setCount(false);
					
					$this->setParametro('id_cotizacion','id_cotizacion','int4');
					
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
    
	

			
}
?>