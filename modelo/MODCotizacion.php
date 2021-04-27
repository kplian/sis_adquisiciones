<?php
/**
*@package pXP
*@file MODCotizacion.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-03-2013 14:48:35
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

   HISTORIAL DE MODIFICACIONES:
       
 ISSUE            FECHA:              AUTOR                 DESCRIPCION
   
 #0               05/09/2013        RAC KPLIAN           Creación
 #16               20/01/2020        RAC KPLIAN          Mejor el rendimiento de la interface de Ordenes y Cotizaciones, issue #16
 #18              22/05/2020           EGS               Campos Adicionales Para Cotizaciones
#ETR-3771          27/04/2021          EGS                 Se agrega el cmp tipo de solicitud
 * */

class MODCotizacion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCotizacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_cotizacion_sel';
		$this->transaccion='ADQ_COT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('groupBy','groupBy','varchar');
        $this->setParametro('groupDir','groupDir','varchar');

        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
        $this->setParametro('historico','historico','varchar');
        
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
		$this->captura('numero','varchar');
		$this->captura('num_tramite','varchar');
		$this->captura('id_obligacion_pago','int4');
		$this->captura('tiempo_entrega','varchar');
		$this->captura('funcionario_contacto','varchar');
		$this->captura('telefono_contacto','varchar');
		$this->captura('correo_contacto','varchar');
		$this->captura('prellenar_oferta','varchar');
		$this->captura('forma_pago','varchar');
		$this->captura('requiere_contrato','varchar');
		$this->captura('total_adjudicado','numeric');
		$this->captura('total_cotizado','numeric');
		$this->captura('total_adjudicado_mb','numeric');
		$this->captura('tiene_form500','varchar');
		$this->captura('correo_oc','varchar');
		
		$this->captura('cecos','varchar');
		$this->captura('total','numeric');
		$this->captura('nro_cuenta','text');
        $this->captura('id_categoria_compra','integer');//#18
        $this->captura('codigo_proceso','varchar');//#18
        $this->captura('desc_categoria_compra','varchar');//#18
        $this->captura('tipo_sol','varchar'); //#TR-3771

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
                
        
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
        $this->setParametro('id_funcionario_rpc','id_funcionario_rpc','int4');
        $this->setParametro('historico','historico','varchar');
        
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
		$this->captura('numero','varchar');
        $this->captura('num_tramite','varchar');
        $this->captura('tiempo_entrega','varchar');
		$this->captura('requiere_contrato','varchar');
		$this->captura('total_adjudicado','numeric');
		$this->captura('total_cotizado','numeric');
		$this->captura('total_adjudicado_mb','numeric');
        
        
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
		$this->setParametro('tiempo_entrega','tiempo_entrega','varchar');
		$this->setParametro('funcionario_contacto','funcionario_contacto','varchar');
		$this->setParametro('telefono_contacto','telefono_contacto','varchar');
		$this->setParametro('correo_contacto','correo_contacto','varchar');
		$this->setParametro('prellenar_oferta','prellenar_oferta','varchar');
		
		$this->setParametro('forma_pago','forma_pago','varchar');
		
		
		
		

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
        $this->setParametro('tiempo_entrega','tiempo_entrega','varchar');
		$this->setParametro('funcionario_contacto','funcionario_contacto','varchar');
		$this->setParametro('telefono_contacto','telefono_contacto','varchar');
		$this->setParametro('correo_contacto','correo_contacto','varchar');
		$this->setParametro('prellenar_oferta','prellenar_oferta','varchar');
		$this->setParametro('forma_pago','forma_pago','varchar');
        
        

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

    function generarNumOC(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_cotizacion_ime';
		$this->transaccion='ADQ_GENOCDE_IME';
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
    
    
    function siguienteEstadoCotizacion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_SIGECOT_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');
        $this->setParametro('operacion','operacion','varchar');
        
        $this->setParametro('id_tipo_estado','id_tipo_estado','integer');
        $this->setParametro('id_funcionario','id_funcionario','integer');
        $this->setParametro('obs','obs','varchar');
        $this->setParametro('fecha_oc','fecha_oc','date');
       

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
		$this->setCount(false);	
		$this->setParametro('id_cotizacion','id_cotizacion','int4');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		
		$this->captura('id_cotizacion','int4');
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
		$this->captura('dias_entrega','int4');
		$this->captura('lugar_entrega','varchar');
		$this->captura('numero_oc','varchar');
		$this->captura('tipo_entrega','varchar');
		$this->captura('id_proceso_compra','int4');
		$this->captura('tipo','varchar');
		$this->captura('fecha_oc','date');
		$this->captura('moneda','varchar');
		$this->captura('codigo_moneda','varchar');
		$this->captura('tiempo_entrega','varchar');
		$this->captura('num_tramite','varchar');
		$this->captura('id_categoria_compra','int4');
		$this->captura('nombre_completo1','varchar');
		$this->captura('celular1','varchar');
		$this->captura('email_empresa','varchar');
		$this->captura('codigo_proceso','varchar');		    
		$this->captura('forma_pago','varchar');
		$this->captura('objeto','varchar');
		$this->captura('codigo_uo','varchar');
		$this->captura('observacion','varchar');
		$this->captura('obs','varchar');
		
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
    /*
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
    }*/
    
    
    function habilitarPago(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_HABPAG_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
		 $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
    

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
	
	function generarPreingreso(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='adq.f_cotizacion_ime';
        $this->transaccion='ADQ_PREING_GEN';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
		//echo $this->consulta;exit;
		
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    
    function SolicitarContrato(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'adq.f_cotizacion_ime';
        $this->transaccion = 'ADQ_SOLCON_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	function habilitarContrato(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'adq.f_cotizacion_ime';
        $this->transaccion = 'ADQ_HABCONT_IME';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
        $this->setParametro('id_cotizacion','id_cotizacion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function cambioFomrulario500(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='adq.f_cotizacion_ime';
		$this->transaccion='ADQ_CBFRM500_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cotizacion','id_cotizacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	function InsertarDiasFaltantesOrdenCompra(){
		//Definicion de variables para ejecucion del procedimiento
		
		
		$this->procedimiento='adq.f_cotizacion_sel';
		$this->transaccion='ADQ_DFOR_CO_SEL';
		$this->tipo_procedimiento='SEL';
		$this->setCount(false);  
		

		$this->tipo_conexion='seguridad';
		
		$this->arreglo=array("id_usuario" =>1,
							 "tipo"=>'TODOS'
							 );
		

						 
		$this->setParametro('id_usuario','id_usuario','int4');						 
			
        $this->captura('id_funcionario_departamento','int4');
		$this->captura('id_usuario_departamento','int4');
		$this->captura('coreo_departamento','varchar');
		
        $this->captura('id_funcionario_gestor','int4');
		$this->captura('id_usuario_gestor','int4');
		$this->captura('correo_gestor','varchar');	
		
        $this->captura('id_funcionario_solicitante','int4');
		$this->captura('id_usuario_solicitante','int4');
		$this->captura('correo_solicitante','varchar');
		
		$this->captura('desc_proveedor','varchar');		
		$this->captura('dias_faltantes','varchar');	
	    //Ejecuta la instruccion
		$this->armarConsulta();
		

		$this->ejecutarConsulta();
		

		/*echo ("entro al cron modelo juan ".$this->consulta.' fin juan');
		exit;*/
		
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    function ListarNumTraCot(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='adq.f_cotizacion_sel';
        $this->transaccion='ADQ_NUMCOT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('num_tramite','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    Function ListarCodigoProcesoCot(){
        //Definicion de variables para ejecucion del procedimientp
    $this->procedimiento='adq.f_cotizacion_sel';
    $this->transaccion='ADQ_CODPRCOT_SEL';
    $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
    $this->captura('codigo_proceso','varchar');

        //Ejecuta la instruccion
    $this->armarConsulta();
    $this->ejecutarConsulta();

        //Devuelve la respuesta
    return $this->respuesta;
    }

			
}
?>