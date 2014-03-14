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

BEGIN

	v_nombre_funcion='adq.f_genera_preingreso';
    v_af = 0;
    v_alm = 0;

	---------------------
    --OBTENCION DE DATOS
    ---------------------
	--Cotización
    select cot.id_cotizacion,cot.id_proceso_wf, cot.id_estado_wf, cot.estado, cot.id_moneda,
    cot.id_obligacion_pago, sol.justificacion, cot.numero_oc
    into v_rec_cot
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
    
    --TODO ................  QUE PASA SI TIENE MAS DE UN PREINGESO
    
    --Verifica que no haya generado ya un Preingreso
    if exists(select 1
              from alm.tpreingreso
              where id_cotizacion = p_id_cotizacion
              and estado in ('borrador','finalizado')) then
    	raise exception 'El Preingreso ya fue generado anteriormente.';
    end if;
	
    --Verifica que la primera cuota haya sido al menos devengada
    select od.estado_reg, op.id_depto
    into v_estado_cuota, v_id_depto_conta
    from tes.tobligacion_pago op
    inner join tes.tobligacion_det od
    on od.id_obligacion_pago = op.id_obligacion_pago
    where op.id_obligacion_pago = v_rec_cot.id_obligacion_pago
    order by od.id_obligacion_det asc limit 1;
    
    /*if v_estado_cuota != 'devengado' then
    	raise exception 'La cotización aún no ha sido Devengada';
    end if;*/
    
    --Verifica que en el detalle de la cotización existan almacenables
    if exists(select 1
                  from adq.tcotizacion_det cdet
                  inner join adq.tsolicitud_det sdet
                  on sdet.id_solicitud_det = cdet.id_solicitud_det
                  inner join param.tconcepto_ingas cin
                  on cin.id_concepto_ingas = sdet.id_concepto_ingas
                  where cdet.id_cotizacion = p_id_cotizacion
                  and lower(cin.tipo) = 'bien' 
                  and lower(cin.almacenable) = 'si') then
        v_alm = 1;
    end if;
    
    if exists(select 1
                  from adq.tcotizacion_det cdet
                  inner join adq.tsolicitud_det sdet
                  on sdet.id_solicitud_det = cdet.id_solicitud_det
                  inner join param.tconcepto_ingas cin
                  on cin.id_concepto_ingas = sdet.id_concepto_ingas
                  where cdet.id_cotizacion = p_id_cotizacion
                  and lower(cin.tipo) = 'bien'
                  and lower(cin.activo_fijo) = 'si' 
                  and lower(cin.almacenable) = 'no') then
        v_af = 1;
    end if;

    if v_alm + v_af = 0 then
    	raise exception 'La cotización no tiene ningún Bien Almacenable ni Activo Fijo. Nada que hacer.';
    end if;

	
    --------------------------
    -- CREACIÓN DE PREINGRESO
    --------------------------
    --Preingreso para almacenes
    if v_alm>0 then
    
    
      -- REgistra el proceso siguiente de la cotización para el Preingreso de almacenes
            
            SELECT ps_id_proceso_wf, ps_id_estado_wf, ps_codigo_estado
            into v_id_proceso_wf, v_id_estado_wf, v_codigo_estado
            FROM wf.f_registra_proceso_disparado_wf(
               p_id_usuario, 
               v_rec_cot.id_estado_wf,
               NULL, 
               v_id_depto, 
               'Preingreso de almacenes',
               'ALPRE,ALPREIND,ALPREND,ALPRENR',  --no tiene que tenes espacios
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
            and cin.almacenable = 'si';
            
    end if;
    
    --Preingreso para Activos Fijos
    if v_af>0 then
    
    
           -- REgistra el proceso siguiente de la cotización para el Preingreso de Aactivo Fijos
            
            SELECT ps_id_proceso_wf, ps_id_estado_wf, ps_codigo_estado
            into v_id_proceso_wf, v_id_estado_wf, v_codigo_estado
            FROM wf.f_registra_proceso_disparado_wf(
               p_id_usuario, 
               v_rec_cot.id_estado_wf,
               NULL, 
               v_id_depto, 
               'Preingreso de activos fijos',
               'ALPRE,ALPREIND,ALPREND,ALPRENR',  --no tiene que tenes espacios
               'PAF-'||v_rec_cot.numero_oc
               );
    
    
    
    
    
            insert into alm.tpreingreso(
            id_usuario_reg, fecha_reg, estado_reg, id_cotizacion,
            id_depto, id_estado_wf, id_proceso_wf, estado, id_moneda,
            tipo
            ) values(
            p_id_usuario, now(),'activo',p_id_cotizacion,
            null, v_id_estado_wf, v_id_proceso_wf, v_codigo_estado, v_id_moneda,
            'activo_fijo'
            ) returning id_preingreso into v_id_preingreso;

            --Generación del detalle del preingreso de activo fijo
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
            and lower(cin.activo_fijo) = 'si'
            and lower(cin.almacenable) = 'no';
    end if;

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