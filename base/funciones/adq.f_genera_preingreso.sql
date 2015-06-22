--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_genera_preingreso (
  p_id_usuario integer,
  p_id_cotizacion integer
)
RETURNS varchar AS
$body$
/*
Autor: RCM
Fecha: 01/10/2013
Descripción: Generar el Preingreso a Almacén o a Activos Fijos

----------------------------------
Autor: 			RAC
Fecha:   		14/03/2014
Descripcion:  	Se generan id_proceso_wf independientes para almances y activos fijos
----------------------------------
Autor: 			RAC
Fecha:   		30/04/2014
Descripcion:  	 Se cambi ala logica de esta funcion,...  
                 1) revisa si no tiene preingresos activos
                 2) porlo menos dee tener un preingreso anulado para recuperar el codigo de proveso
                     la unica de forma de crear nuevos preingresos es con la funcion de habilitar pago
                 3)  genera preignreso de almacens  y activos fijos 

*/

DECLARE

	v_rec_cot record;
    v_rec_cot_det record;
    v_id_preingreso integer;
    v_id_proceso_wf integer;
    v_id_estado_wf integer;
    v_codigo_estado varchar;
    v_id_moneda	integer;
    v_resp varchar;
    v_precio_compra numeric;
    v_nombre_funcion varchar;
    v_estado_cuota varchar;
    v_id_depto integer;
    v_af integer;
    v_alm integer;
    v_id_depto_conta integer;
    v_almacenable varchar;
    v_activo_fijo varchar;
    v_sw_al boolean;
    v_id_tipo_proceso_pi_al  integer;
    v_codigo_proceso_pi_al  varchar;
    v_id_fun_proceso_pi_al integer;
    v_id_dep_proceso_pi_al integer;
    v_sw_af boolean;
    v_id_tipo_proceso_pi_af  integer;
    v_codigo_proceso_pi_af varchar;
    v_id_fun_proceso_pi_af integer;
    v_id_dep_proceso_pi_af integer;

BEGIN

	v_nombre_funcion='adq.f_genera_preingreso';
    v_af = 0;
    v_alm = 0;

	 ---------------------
    --OBTENCION DE DATOS
    ---------------------
	--Cotización
    select 
       cot.id_cotizacion,
       cot.id_proceso_wf, 
       cot.id_estado_wf, 
       cot.estado, 
       cot.id_moneda,
       cot.id_obligacion_pago, 
       sol.justificacion, 
       cot.numero_oc
    into 
       v_rec_cot
    from adq.tcotizacion cot
    inner join adq.tproceso_compra pro on pro.id_proceso_compra = cot.id_proceso_compra
    inner join adq.tsolicitud sol on sol.id_solicitud = pro.id_solicitud
    where cot.id_cotizacion = p_id_cotizacion;
    
    --Moneda Base
    v_id_moneda = param.f_get_moneda_base();
    
    
    ---------------
    --VALIDACIONES
    ---------------
	--Existencia de la cotización en estado 'pago_habilitado'
	if v_rec_cot.id_cotizacion is null then
    	raise exception 'Cotización no encontrada';
    end if;
    
    if v_rec_cot.id_obligacion_pago is null then
    	raise exception 'La Cotización aún no ha sido habilitada para Pago';
    end if;
    
    
    
    ---------------------------
    --  PREINGRESO DE ALMACENES
    -------------------------------
    
    
    -- obtener los preingresos de AL  cancelado, y verificar que no se tenga activos (borrador o finalizado)
    
    v_sw_al = false;
    
    if exists(select 1
                from alm.tpreingreso  pi
                inner join wf.tproceso_wf  pw on pw.id_proceso_wf = pi.id_proceso_wf
                inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pw.id_tipo_proceso
                where pi.id_cotizacion = p_id_cotizacion 
                   and tp.codigo_llave = 'preingreso_almacen'
                    and estado in ('cancelado')) then
    	
        
        v_sw_al = true ;  
    
    end if;
    
    
    if exists(select 1
              from alm.tpreingreso  pi
              inner join wf.tproceso_wf  pw on pw.id_proceso_wf = pi.id_proceso_wf
                inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pw.id_tipo_proceso
              where pi.id_cotizacion = p_id_cotizacion 
               and tp.codigo_llave = 'preingreso_almacen'
              and estado in ('borrador','finalizado')) then
    	
         v_sw_al = false;   
    
    end if;
    
    -- obtener preingresos de AF cancelado, y verificar que no se tenga activos (borrador o finalizado)
    
    
    --IF si existe un Preingreso de almacens,cancelado  y no se tiene estado borrador ni finalizado
     IF  v_sw_al  THEN
            -- obtenemos el id_tipo_proceso, y el id_estado_wf anterior
             select 
               tp.id_tipo_proceso,
               tp.codigo,
               ewf.id_funcionario,
               ewf.id_depto
            into
               v_id_tipo_proceso_pi_al,
               v_codigo_proceso_pi_al,
               v_id_fun_proceso_pi_al,
               v_id_dep_proceso_pi_al
            from alm.tpreingreso  pi
            inner join wf.tproceso_wf  pw on pw.id_proceso_wf = pi.id_proceso_wf
            inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pw.id_tipo_proceso
            inner join wf.testado_wf ewf on ewf.id_proceso_wf = pw.id_proceso_wf 
            inner join wf.ttipo_estado tew on tew.id_tipo_estado = ewf.id_tipo_estado  and tew.codigo = 'borrador'
            where pi.id_cotizacion = p_id_cotizacion 
             and  tp.codigo_llave = 'preingreso_almacen'
            and estado in ('cancelado')
            offset  0 limit 1;
            
            --Verifica que en el detalle de la cotización existan almacenables
            if exists(select 1
                          from adq.tcotizacion_det cdet
                          inner join adq.tsolicitud_det sdet
                              on sdet.id_solicitud_det = cdet.id_solicitud_det
                          inner join param.tconcepto_ingas cin
                              on cin.id_concepto_ingas = sdet.id_concepto_ingas
                          where cdet.id_cotizacion = p_id_cotizacion
                            and cdet.estado_reg = 'activo'
                            and cdet.cantidad_adju > 0
                            and lower(cin.tipo) = 'bien' 
                            and lower(cin.almacenable) = 'si'
                            and lower(cin.activo_fijo) = 'no') then
                v_alm = 1;
            end if;
            
            -- registramo un  nuevo proceso de de preingreso de almacenes
            -- copiamos los datos de la cotizacion detalle
            
            --------------------------
            -- CREACIÓN DE PREINGRESO
            --------------------------
            --Preingreso para almacenes
            if v_alm>0 then
            
            
              -- REgistra el proceso siguiente de la cotización para el Preingreso de almacenes
                    
                    SELECT 
                      ps_id_proceso_wf, ps_id_estado_wf, ps_codigo_estado
                    into 
                      v_id_proceso_wf, v_id_estado_wf, v_codigo_estado
                    FROM wf.f_registra_proceso_disparado_wf(
                       p_id_usuario, 
                       v_rec_cot.id_estado_wf,
                       v_id_fun_proceso_pi_al, 
                       v_id_dep_proceso_pi_al, 
                      'Preingreso de almacenes',
                       v_codigo_proceso_pi_al,  --no tiene que tenes espacios
                      'PAL-'||v_rec_cot.numero_oc
                       );
                       
                   
                  insert into alm.tpreingreso(
                       id_usuario_reg, 
                       fecha_reg, 
                       estado_reg, 
                       id_cotizacion,
                       id_depto, 
                       id_estado_wf, 
                       id_proceso_wf,  
                       estado, 
                       id_moneda,
                       tipo, 
                       descripcion, 
                       id_depto_conta
                    ) values(
                       p_id_usuario, 
                       now(),
                       'activo',
                       p_id_cotizacion,
                       null, 
                       v_id_estado_wf, 
                       v_id_proceso_wf, 
                       v_codigo_estado, 
                       v_id_moneda,
                       'almacen', 
                       v_rec_cot.justificacion, 
                       v_id_depto_conta
                    ) returning id_preingreso into v_id_preingreso;
                    
                    --Generación del detalle del preingreso  de activo fijo
                    insert into alm.tpreingreso_det(
                    id_usuario_reg, fecha_reg, estado_reg,
                    id_preingreso, id_cotizacion_det, cantidad_det, precio_compra
                    )
                    select
                    p_id_usuario, now(),'activo',
                    v_id_preingreso,cdet.id_cotizacion_det, cdet.cantidad_adju, cdet.precio_unitario_mb
                    from adq.tcotizacion_det cdet
                    inner join adq.tsolicitud_det sdet
                    on sdet.id_solicitud_det = cdet.id_solicitud_det
                    inner join param.tconcepto_ingas cin
                    on cin.id_concepto_ingas = sdet.id_concepto_ingas
                    where cdet.id_cotizacion = p_id_cotizacion
                    and lower(cin.tipo) = 'bien'
                    and cin.almacenable = 'si'
                    and lower(cin.activo_fijo) = 'no';
            
             end if;
    
    
    END IF;
    
    
    ------------------------------------
    --  PREINGRESO DE activos fijos  ---
    ------------------------------------
    
    
    -- obtener los preingresos de AF  cancelado, y verificar que no se tenga activos (borrador o finalizado)
    
    v_sw_af = false;
    
    if exists(select 1
                from alm.tpreingreso  pi
                inner join wf.tproceso_wf  pw on pw.id_proceso_wf = pi.id_proceso_wf
                inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pw.id_tipo_proceso
                where pi.id_cotizacion = p_id_cotizacion 
                   and tp.codigo_llave = 'preingreso_activo_fijo'
                   and estado in ('cancelado')) then
    	  
          v_sw_af = true ;  
    
    end if;
    
    
    IF exists(select 1
              from alm.tpreingreso  pi
              inner join wf.tproceso_wf  pw on pw.id_proceso_wf = pi.id_proceso_wf
                inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pw.id_tipo_proceso
              where pi.id_cotizacion = p_id_cotizacion 
               and tp.codigo_llave = 'preingreso_activo_fijo'
              and estado in ('borrador','finalizado')) then
    	
         v_sw_af = false;   
    
    end IF;
    
    --IF si existe un Preingreso de almacens,cancelado  y no se tiene estado borrador ni finalizado
   
    IF  v_sw_af  THEN
            -- obtenemos el id_tipo_proceso, y el id_estado_wf anterior
             select 
               tp.id_tipo_proceso,
               tp.codigo,
               ewf.id_funcionario,
               ewf.id_depto
            into
               v_id_tipo_proceso_pi_af,
               v_codigo_proceso_pi_af,
               v_id_fun_proceso_pi_af,
               v_id_dep_proceso_pi_af
            from alm.tpreingreso  pi
            inner join wf.tproceso_wf  pw on pw.id_proceso_wf = pi.id_proceso_wf
            inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pw.id_tipo_proceso
            inner join wf.testado_wf ewf on ewf.id_proceso_wf = pw.id_proceso_wf
            inner join wf.ttipo_estado tew on tew.id_tipo_estado = ewf.id_tipo_estado  and tew.codigo = 'borrador'
            where pi.id_cotizacion = p_id_cotizacion 
             and  tp.codigo_llave = 'preingreso_activo_fijo'
            and estado in ('cancelado')
            offset  0 limit 1;
            
            
            
            --Verifica que en el detalle de la cotización existan almacenables
            if exists(select 1
                          from adq.tcotizacion_det cdet
                          inner join adq.tsolicitud_det sdet
                              on sdet.id_solicitud_det = cdet.id_solicitud_det
                          inner join param.tconcepto_ingas cin
                              on cin.id_concepto_ingas = sdet.id_concepto_ingas
                          where cdet.id_cotizacion = p_id_cotizacion
                            and cdet.estado_reg = 'activo'
                            and cdet.cantidad_adju > 0
                            and lower(cin.tipo) = 'bien' 
                            and lower(cin.almacenable) = 'no'
                            and lower(cin.activo_fijo) = 'si') then
                            
                             
                            
                v_af = 1;
            end if;
            
            -- registramo un  nuevo proceso de de preingreso de almacenes
            -- copiamos los datos de la cotizacion detalle
            
            --------------------------
            -- CREACIÓN DE PREINGRESO
            --------------------------
            --Preingreso para almacenes
            if v_af > 0 then
            
            
              -- REgistra el proceso siguiente de la cotización para el Preingreso de almacenes
                    
                    SELECT 
                      ps_id_proceso_wf, ps_id_estado_wf, ps_codigo_estado
                    into 
                      v_id_proceso_wf, v_id_estado_wf, v_codigo_estado
                    FROM wf.f_registra_proceso_disparado_wf(
                       p_id_usuario, 
                       v_rec_cot.id_estado_wf,
                       v_id_fun_proceso_pi_af, 
                       v_id_dep_proceso_pi_af, 
                      'Preingreso de activos fijos',
                       v_codigo_proceso_pi_af, 
                      'PAF-'||v_rec_cot.numero_oc
                       );
                       
                   
                  insert into alm.tpreingreso(
                       id_usuario_reg, 
                       fecha_reg, 
                       estado_reg, 
                       id_cotizacion,
                       id_depto, 
                       id_estado_wf, 
                       id_proceso_wf,  
                       estado, 
                       id_moneda,
                       tipo, 
                       descripcion, 
                       id_depto_conta
                    ) values(
                       p_id_usuario, 
                       now(),
                       'activo',
                       p_id_cotizacion,
                       null, 
                       v_id_estado_wf, 
                       v_id_proceso_wf, 
                       v_codigo_estado, 
                       v_id_moneda,
                       'activo_fijo', 
                       v_rec_cot.justificacion, 
                       v_id_depto_conta
                    ) returning id_preingreso into v_id_preingreso;
                    
                    --Generación del detalle del preingreso  de activo fijo
                    insert into alm.tpreingreso_det(
                    id_usuario_reg, fecha_reg, estado_reg,
                    id_preingreso, id_cotizacion_det, cantidad_det, precio_compra
                    )
                    select
                     p_id_usuario, now(),'activo',
                     v_id_preingreso,cdet.id_cotizacion_det, cdet.cantidad_adju, cdet.precio_unitario_mb
                    from adq.tcotizacion_det cdet
                    inner join adq.tsolicitud_det sdet
                    on sdet.id_solicitud_det = cdet.id_solicitud_det
                    inner join param.tconcepto_ingas cin
                    on cin.id_concepto_ingas = sdet.id_concepto_ingas
                    where cdet.id_cotizacion = p_id_cotizacion
                    and lower(cin.tipo) = 'bien'
                    and cin.almacenable = 'no'
                    and lower(cin.activo_fijo) = 'si';
            
             end if;
    
    
    END IF;
   



    ------------
    --RESPUESTA
    ------------
    if v_alm + v_af = 2 then
    	v_resp = 'Se han generado dos Preingresos, uno para Almacenes y otro para Activos Fijos';
    elsif v_alm = 1 and v_af = 0 then
    	v_resp = 'Se ha generado un Preingreso para Almacenes';
    elsif v_af = 1 and v_alm = 0 then
    	v_resp = 'Se ha generado un Preingreso para Activos Fijos';
    else
    	raise exception 'No se ha generado ningún preingreso';
    end if;
    
    return v_resp;
    
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