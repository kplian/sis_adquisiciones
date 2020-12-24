<?php
/**
*@package pXP
*@file gen-MODPlanPago.php
*@author  (admin)
*@date 10-04-2013 15:43:23
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*@date 30/08/2018
*@description añadida la columna retenciones de garantía para mostrar el reporte de solicitud de pago

*	ISSUE FORK 	        Fecha 		 Autor				Descripcion	
*   #1			        16/102016		EGS			Se aumento el campo pago borrador y sus respectivas validaciones 
 	#5	 EndeETR		27/12/2018		EGS			Se añadio el dato de codigo de proveedor
 *  #35  ETR            07/10/2019      RAC         Adicionar descuento de anticipos en reporte de plan de pagos 
 *  #41  ENDETR         16/12/2019      JUAN        Reporte de información de pago

 * * */

class MODPlanPagoRep extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarPlanPagoRep(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_plan_pago_rep_sel';
		$this->transaccion='ADQ_PLAPAREP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion


		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
        $this->setParametro('historico','historico','varchar');

        $this->setParametro('groupBy','groupBy','varchar');
        $this->setParametro('groupDir','groupDir','varchar');

        //Definicion de la lista del resultado del query
        $this->captura('num_tramite','varchar');
        $this->captura('id_depto','int4');
        $this->captura('nombre_depto_obp','varchar');
        $this->captura('id_proveedor','int4');
        $this->captura('desc_proveedor','varchar');
		$this->captura('id_plan_pago','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nro_cuota','numeric');
		$this->captura('monto_ejecutar_total_mb','numeric');
		$this->captura('nro_sol_pago','varchar');
		$this->captura('tipo_cambio','numeric');
		$this->captura('fecha_pag','date');
		$this->captura('id_proceso_wf','int4');
		$this->captura('fecha_dev','date');
		$this->captura('estado','varchar');
		$this->captura('tipo_pago','varchar');
		$this->captura('monto_ejecutar_total_mo','numeric');
		$this->captura('descuento_anticipo_mb','numeric');
		$this->captura('obs_descuentos_anticipo','text');
		$this->captura('id_plan_pago_fk','int4');
		$this->captura('id_obligacion_pago','int4');
		$this->captura('id_plantilla','int4');
		$this->captura('descuento_anticipo','numeric');
		$this->captura('otros_descuentos','numeric');
		$this->captura('tipo','varchar');
		$this->captura('obs_monto_no_pagado','text');
		$this->captura('obs_otros_descuentos','text');
		$this->captura('monto','numeric');
		$this->captura('id_int_comprobante','int4');
		$this->captura('nombre_pago','varchar');
		$this->captura('monto_no_pagado_mb','numeric');
		$this->captura('monto_mb','numeric');
		$this->captura('id_estado_wf','int4');
		$this->captura('id_cuenta_bancaria','int4');
		$this->captura('otros_descuentos_mb','numeric');
		$this->captura('forma_pago','varchar');
		$this->captura('monto_no_pagado','numeric');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('fecha_tentativa','date');
		$this->captura('desc_plantilla','varchar');
		$this->captura('liquido_pagable','numeric');
		$this->captura('total_prorrateado','numeric');
		$this->captura('total_pagado','numeric');
        $this->captura('desc_cuenta_bancaria','text');
        $this->captura('sinc_presupuesto','varchar');
        $this->captura('monto_retgar_mb','numeric');
        $this->captura('monto_retgar_mo','numeric');
        $this->captura('descuento_ley','numeric');
        $this->captura('obs_descuentos_ley','text');
        $this->captura('descuento_ley_mb','numeric');
        $this->captura('porc_descuento_ley','numeric');
        $this->captura('nro_cheque','integer');
		$this->captura('nro_cuenta_bancaria','varchar');
		$this->captura('id_cuenta_bancaria_mov','integer');
		$this->captura('desc_deposito','varchar');
		$this->captura('numero_op','varchar');
		$this->captura('id_depto_conta','integer');
		$this->captura('id_moneda','integer');
		$this->captura('tipo_moneda','varchar');
		$this->captura('desc_moneda','varchar');
		$this->captura('porc_monto_excento_var','numeric');
		$this->captura('monto_excento','numeric');
		$this->captura('obs_wf','text');
		$this->captura('obs_descuento_inter_serv','text');
		$this->captura('descuento_inter_serv','numeric');
		$this->captura('porc_monto_retgar','numeric');
		$this->captura('desc_funcionario1','text');
		$this->captura('revisado_asistente','varchar');
		$this->captura('conformidad','text');
		$this->captura('fecha_conformidad','date');
		$this->captura('tipo_obligacion','varchar');
		$this->captura('monto_ajuste_ag','numeric');
		$this->captura('monto_ajuste_siguiente_pag','numeric');
		$this->captura('pago_variable','varchar');
		$this->captura('monto_anticipo','numeric');
		$this->captura('fecha_costo_ini','date');
		$this->captura('fecha_costo_fin','date');
		$this->captura('funcionario_wf','text');
		$this->captura('tiene_form500','varchar');
		$this->captura('id_depto_lb','integer');
		$this->captura('desc_depto_lb','varchar');
		$this->captura('ultima_cuota_dev','numeric');

		$this->captura('id_depto_conta_pp','integer');
		$this->captura('desc_depto_conta_pp','varchar');
		$this->captura('contador_estados','bigint');
		$this->captura('prioridad_lp','integer');
		//$this->captura('es_ultima_cuota','boolean');
		$this->captura('id_gestion','integer');
		$this->captura('id_periodo','integer');


		$this->captura('pago_borrador','varchar'); //#1			16/102016		EGS
        $this->captura('codigo_tipo_anticipo', 'varchar');
        $this->captura('cecos', 'varchar');



		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}


    function ListarNumTraObp(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='adq.f_plan_pago_rep_sel';
        $this->transaccion='ADQ_OBPNUM_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('num_tramite','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
	}
	//
	function listarReporteConsulta(){
		$this->procedimiento='adq.f_plan_pago_rep_sel';
		$this->transaccion='ADQ_CONSREP_SEL';
		$this->tipo_procedimiento='SEL';
		
		$this->captura('num_tramite','varchar');
		$this->captura('justificacion','varchar');
		//$this->captura('id_proveedor','int4');
		$this->captura('desc_proveedor','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('desc_funcionario','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('moneda','varchar');
		
		//$this->captura('fecha_reg','date');
		$this->captura('fecha_adju','date');
		$this->captura('fecha_apro','date');
		$this->captura('cecos','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_categoria_compra','int4');

		$this->captura('monto_total_adjudicado','numeric');
		$this->captura('monto_total_adjudicado_mb','numeric');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	//
	function recuperarConsulta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='adq.f_plan_pago_rep_sel';
		$this->transaccion='ADQ_CONSREP_REP';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
	  
		//captura parametros adicionales para el count
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('num_tramite','num_tramite','varchar');
		$this->setParametro('id_proveedor','id_proveedor','int4');
		$this->setParametro('codigo_tcc','codigo_tcc','varchar');
		$this->setParametro('id_categoria_compra','id_categoria_compra','int4');
		//Definicion de la lista del resultado del query
		$this->captura('num_tramite','varchar');
		$this->captura('justificacion','varchar');
		//$this->captura('id_proveedor','int4');
		$this->captura('desc_proveedor','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('desc_funcionario','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('moneda','varchar');
		
		//$this->captura('fecha_reg','date');
		$this->captura('fecha_adju','date');
		$this->captura('fecha_apro','date');
		$this->captura('cecos','varchar');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_categoria_compra','int4');

		$this->captura('monto_total_adjudicado','numeric');
		$this->captura('monto_total_adjudicado_mb','numeric');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
}
?>