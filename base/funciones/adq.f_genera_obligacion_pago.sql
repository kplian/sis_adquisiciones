--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_genera_obligacion_pago (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_cotizacion integer,
  p_id_proceso_wf integer,
  p_id_estado_wf integer,
  p_codigo_ewf varchar,
  p_tipo_preingreso varchar,
  p_id_depto_wf_pro integer
)
RETURNS boolean AS
$body$
/*
Autor: RAC
Fecha: 26/02/2015
Descripción: Generar Obligaciones de pago

 

*/

DECLARE

	v_nombre_funcion  				varchar;
    v_registros_cotizacion			record;
    v_registros 					record;
    v_id_subsistema					integer;
    v_id_obligacion_pago 			integer;
    v_id_obligacion_det 			integer;
    v_resp							varchar;
    v_id_contrato					integer;

	

BEGIN

	v_nombre_funcion='adq.f_genera_obligacion_pago';
    
    
             select 
           	 s.id_subsistema
            into
            	v_id_subsistema
            from segu.tsubsistema s 
            where s.codigo = 'ADQ';
    
            -------------------------------------
            --recuperar datos de la cotizacion e inserta en oblligacion
            ------------------------------------------------
      
            select 
              c.id_cotizacion,
              c.numero_oc,
              c.id_proveedor,
              c.id_estado_wf,
              c.id_proceso_wf,
              c.id_moneda,
              pc.id_depto,
              pc.num_tramite,
              c.estado,
              c.tipo_cambio_conv,
              sol.id_gestion,
              sol.id_categoria_compra,
              sol.tipo,
              sol.tipo_concepto,
              sol.id_funcionario,
              c.requiere_contrato,
              sol.justificacion
            into
             v_registros_cotizacion
            from adq.tcotizacion c
            inner join adq.tproceso_compra pc on pc.id_proceso_compra = c.id_proceso_compra
            inner join adq.tsolicitud sol on sol.id_solicitud = pc.id_solicitud
            WHERE c.id_cotizacion = p_id_cotizacion;            
            
            IF  v_registros_cotizacion.estado  in('adjudicado','contrato_elaborado') THEN
              raise exception 'Solo pueden habilitarce pago para cotizaciones adjudicadas';
            END IF;
            
            
            
            --------------------------------------
            --  Recuperamos datos del contrato si que existe
            -------------------------------------
            v_id_contrato = NULL;
            IF v_registros_cotizacion.requiere_contrato = 'si'  THEN
              
                 select 
                 	con.id_contrato
                 into
                    v_id_contrato
                 from leg.tcontrato con
                 where  con.id_cotizacion = p_id_cotizacion 
                        and con.estado = 'finalizado' and con.estado_reg = 'activo';
            
            END IF;
            
          
            INSERT INTO 
              tes.tobligacion_pago 
            (
              id_usuario_reg,
              fecha_reg,
              estado_reg,
              id_proveedor,
              id_subsistema,
              id_moneda,
             -- id_depto,
              tipo_obligacion,
              fecha,
              numero,
              tipo_cambio_conv,
              num_tramite,
              id_gestion,
              comprometido,
              id_categoria_compra,
              tipo_solicitud,
              tipo_concepto_solicitud,
              id_funcionario,
              id_contrato,
              obs
            ) 
            VALUES (
              p_id_usuario,
              now(),
              'activo',
              v_registros_cotizacion.id_proveedor,
              v_id_subsistema,
              v_registros_cotizacion.id_moneda,
              'adquisiciones',
              now(),
              v_registros_cotizacion.numero_oc,
              v_registros_cotizacion.tipo_cambio_conv,
              v_registros_cotizacion.num_tramite,
              v_registros_cotizacion.id_gestion,
              'si',
              v_registros_cotizacion.id_categoria_compra,
              v_registros_cotizacion.tipo,
              v_registros_cotizacion.tipo_concepto,
              v_registros_cotizacion.id_funcionario,
              v_id_contrato,
              v_registros_cotizacion.justificacion
              
            ) RETURNING id_obligacion_pago into v_id_obligacion_pago;
    
            
                       
            
            -----------------------------------------------------------------------------
            --recupera datos del detalle de cotizacion e inserta en detalle de obligacion
            -----------------------------------------------------------------------------
            
            FOR v_registros in (
              select 
                cd.id_cotizacion_det,
                sd.id_concepto_ingas,
                sd.id_cuenta,
                sd.id_auxiliar,
                sd.id_partida,
                sd.id_partida_ejecucion,
                cd.cantidad_adju,
                cd.precio_unitario,
                cd.precio_unitario_mb,
                sd.id_centro_costo,
                sd.descripcion,
                sd.id_orden_trabajo
              from adq.tcotizacion_det cd
              inner join adq.tsolicitud_det sd on sd.id_solicitud_det = cd.id_solicitud_det
              where cd.id_cotizacion = p_id_cotizacion 
                    and cd.estado_reg='activo'
              
            )LOOP
            
            
              --TO DO,  para el pago de dos gestion  gestion hay que  
              --        mandar solamente el total comprometido  de la gestion actual menos el revrtido
              --         o el monto total adjudicado, el que sea menor.  
            
               -- inserta detalle obligacion
                IF((v_registros.cantidad_adju * v_registros.precio_unitario) > 0)THEN
                   
                       INSERT INTO 
                        tes.tobligacion_det
                      (
                        id_usuario_reg,
                        fecha_reg,
                        estado_reg,
                        id_obligacion_pago,
                        id_concepto_ingas,
                        id_centro_costo,
                        id_partida,
                        id_cuenta,
                        id_auxiliar,
                        id_partida_ejecucion_com,
                        monto_pago_mo,
                        monto_pago_mb,
                        descripcion,
                        id_orden_trabajo) 
                      VALUES (
                        p_id_usuario,
                        now(),
                        'activo',
                        v_id_obligacion_pago,
                        v_registros.id_concepto_ingas,
                        v_registros.id_centro_costo,
                        v_registros.id_partida,
                        v_registros.id_cuenta,
                        v_registros.id_auxiliar,
                        v_registros.id_partida_ejecucion,
                        (v_registros.cantidad_adju *v_registros.precio_unitario), 
                        (v_registros.cantidad_adju *v_registros.precio_unitario_mb),
                        v_registros.descripcion,
                        v_registros.id_orden_trabajo
                      )RETURNING id_obligacion_det into v_id_obligacion_det;
                       
                       -- actulizar detalle de cotizacion
                       
                       update adq.tcotizacion_det set 
                       id_obligacion_det = v_id_obligacion_det
                       where id_cotizacion_det=v_registros.id_cotizacion_det;
                   
               END IF;
            
            END LOOP;
            
            
              -- actualiza estado en la solicitud
               update adq.tcotizacion  c set 
               id_obligacion_pago = v_id_obligacion_pago
              where c.id_cotizacion  = p_id_cotizacion;
             
              IF  p_id_depto_wf_pro::integer  is NULL  THEN
                          
                 raise exception 'Para obligaciones de pago el depto es indispensable';
                            
              END IF;
                       
               update tes.tobligacion_pago  o set 
                   id_estado_wf =  p_id_estado_wf,
                   id_proceso_wf = p_id_proceso_wf,
                   id_depto =   p_id_depto_wf_pro::integer,
                   estado = p_codigo_ewf,
                   id_usuario_mod=p_id_usuario,
                   fecha_mod=now(),
                   id_usuario_ai = p_id_usuario_ai,
                   usuario_ai = p_usuario_ai
                   where o.id_obligacion_pago  = v_id_obligacion_pago;
                             
             
	
    return TRUE;
    
EXCEPTION
	WHEN OTHERS THEN
      v_resp='';
      v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
      v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
      v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
      raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;