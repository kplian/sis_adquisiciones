--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_genera_preingreso_af_al (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_cotizacion integer,
  p_id_proceso_wf integer,
  p_id_estado_wf integer,
  p_codigo_ewf varchar,
  p_tipo_preingreso varchar
)
RETURNS boolean AS
$body$
/*
Autor: RCM
Fecha: 01/10/2013
Descripción: Generar el Preingreso a Activos Fijos

----------------------------------
Autor:      RAC
Fecha:      14/03/2014
Descripcion:    Se generan id_proceso_wf independientes para almances y activos fijos



*/

DECLARE

  v_rec_cot record;
    v_rec_cot_det record;
    v_id_preingreso integer;
    v_id_proceso_wf integer;
    v_id_estado_wf integer;
    v_codigo_estado varchar;
    v_id_moneda integer;
    v_resp varchar;
    v_precio_compra numeric;
    v_nombre_funcion varchar;
    v_estado_cuota varchar;
    v_id_depto integer;
    v_af integer;
    v_id_depto_conta integer;
    
    v_almacenable  varchar;
    v_activo_fijo  varchar;
    v_tipo   varchar;
    v_mensaje varchar;
   

BEGIN

 
  
  v_nombre_funcion='adq.f_genera_preingreso_af_al';
    v_af = 0;
    
    --inicia variable
    IF p_tipo_preingreso = 'preingreso_activo_fijo' THEN
    
      v_almacenable = 'no';
      v_activo_fijo = 'si';
      v_tipo = 'activo_fijo';
      v_mensaje = 'Activo Fijo';
    
    ELSIF   p_tipo_preingreso = 'preingreso_almacen' THEN
    
      v_almacenable = 'si';
      v_activo_fijo = 'no';
      v_tipo = 'almacen';
      v_mensaje = 'Item';
    
    ELSE
    
       raise exception 'No se reconoce el tipo de preingreso';
    
    END IF;
    
   
   
    
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
  
    
     if exists(select 1
              from alm.tpreingreso pi
              inner join  wf.tproceso_wf pwf on pwf.id_proceso_wf = pi.id_proceso_wf
              inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = pwf.id_tipo_proceso
              where pi.id_cotizacion = p_id_cotizacion
              and  tp.codigo_llave = p_tipo_preingreso
              and estado in ('borrador','finalizado')) then
      raise exception 'El Preingreso ya fue generado anteriormente.';
    end if;
    
     if EXISTS(select 1
                  from adq.tcotizacion_det cdet
                  inner join adq.tsolicitud_det sdet
                  on sdet.id_solicitud_det = cdet.id_solicitud_det
                  inner join param.tconcepto_ingas cin
                  on cin.id_concepto_ingas = sdet.id_concepto_ingas
                  where cdet.id_cotizacion = p_id_cotizacion
                    and cdet.estado_reg = 'activo'
                    and cdet.cantidad_adju > 0
                    and lower(cin.tipo) = 'bien'
                    and lower(cin.activo_fijo) = v_activo_fijo 
                    and lower(cin.almacenable) = v_almacenable) then
        v_af = 1;
    end if;
    
    
    if  v_af = 0 then
     raise exception 'El concepto esta marcado como activo y almacenable simultaneamente';
    end if;
    
    
    --------------------------
    -- CREACIÓN DE PREINGRESO
    --------------------------
     
    
    --Preingreso para Activos Fijos
    if v_af > 0 then
    
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
              id_usuario_ai,
              usuario_ai
            ) 
            values(
              p_id_usuario, 
              now(),
              'activo',
              p_id_cotizacion,
              null, 
              p_id_estado_wf, 
              p_id_proceso_wf, 
              p_codigo_ewf, 
              v_id_moneda,
              v_tipo,
              p_id_usuario_ai,
              p_usuario_ai
            ) returning id_preingreso into v_id_preingreso;
            
            
      

            --Generación del detalle del preingreso de activo fijo
            insert into alm.tpreingreso_det(
              id_usuario_reg, fecha_reg, estado_reg,
              id_preingreso, id_cotizacion_det, cantidad_det, precio_compra,
              id_usuario_ai,usuario_ai,estado,nombre, descripcion, precio_compra_87,
              id_lugar,ubicacion
            )
            select
              p_id_usuario, now(),'activo',        
              v_id_preingreso,cdet.id_cotizacion_det, cdet.cantidad_adju, cdet.precio_unitario_mb,
              p_id_usuario_ai,p_usuario_ai,'orig',cin.desc_ingas,sdet.descripcion,
              (case when s.num_tramite like 'CNAPD%' THEN
               cdet.precio_unitario_mb * 0.87
               else
               cdet.precio_unitario_mb * 0.87
               end), lug.id_lugar,ofi.nombre	 
            from adq.tcotizacion_det cdet
            inner join adq.tsolicitud_det sdet
            on sdet.id_solicitud_det = cdet.id_solicitud_det
            inner join adq.tsolicitud s
            on s.id_solicitud = sdet.id_solicitud
            left join orga.tuo_funcionario uofun
            on s.id_funcionario = uofun.id_funcionario and uofun.estado_reg = 'activo' and
            uofun.tipo = 'oficial' and uofun.fecha_asignacion < s.fecha_soli and 
            ( uofun.fecha_finalizacion >= s.fecha_soli or uofun.fecha_finalizacion is null)
            left join orga.tcargo car on car.id_cargo = uofun.id_cargo
            left join orga.toficina ofi on ofi.id_oficina = car.id_oficina
            left join param.tlugar lug on lug.id_lugar = ofi.id_lugar 
            inner join param.tconcepto_ingas cin
            on cin.id_concepto_ingas = sdet.id_concepto_ingas
            where cdet.id_cotizacion = p_id_cotizacion
            and lower(cin.tipo) = 'bien'
            and lower(cin.activo_fijo) = v_activo_fijo
            and lower(cin.almacenable) = v_almacenable;
    end if;



 return true;

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