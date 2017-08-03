--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_genera_contrato (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_cotizacion integer,
  p_id_proceso_wf integer,
  p_id_estado_wf integer,
  p_codigo_ewf varchar,
  p_codigo_llave varchar
)
RETURNS boolean AS
$body$
/*
Autor: JRR
Fecha: 22/09/2014
Descripción: Generar la solicitud de elaboracion de contrato en el Sistema de Contratos


*/

DECLARE

	v_cotizacion 	 				record;
    v_solicitud 	 				text;
    v_resp			 				varchar;
    v_nombre_funcion 				varchar;
    v_tipo							varchar;
    v_id_tipo_estado_registro		integer;
    v_id_funcionario_responsable	integer;
    v_id_estado_registro			integer;
    v_id_lugar						integer;
    v_adq_estado_contrato_siguiente			varchar;
    
    
    va_id_tipo_estado 			integer [];
    va_codigo_estado 			varchar [];
    va_disparador 				varchar [];
    va_regla 					varchar [];
    va_prioridad 				integer [];
    v_num_estados				integer;
    v_num_funcionarios			integer;
    v_num_deptos				integer;
    v_id_funcionario_estado		integer;
    v_id_depto_estado			integer;




BEGIN

	v_nombre_funcion='adq.f_genera_contrato';
  
     
     
     select c.*,s.id_funcionario,s.id_funcionario_aprobador,
     		s.id_funcionario_rpc,s.fecha_inicio,s.justificacion
     into 	v_cotizacion
     from adq.vcotizacion c
     inner join adq.tsolicitud s on s.id_solicitud = c.id_solicitud
     where id_cotizacion = p_id_cotizacion;

     if (v_cotizacion.nombre_categoria = 'Compra Internacional') then
     	v_tipo = 'administrativo_internacional';
        if (lower(coalesce(v_cotizacion.precontrato,'no')) = 'si') THEN
        	v_id_lugar = 2;
        end if;
     elsif (v_cotizacion.tipo_concepto = 'alquiler_inmueble') then
     	v_tipo = 'administrativo_alquiler';
     ELSE
     	v_tipo = 'administrativo';
     end if;

     v_solicitud = 'Por favor realizar contrato para la solicitud de compra con numero de tramite : ' ||
     				v_cotizacion.num_tramite || '. Categoria : ' || v_cotizacion.nombre_categoria || '. Concepto : ' || v_cotizacion.tipo_concepto;

     /*Obtener el estado de registro*/
     select 
        te.id_tipo_estado 
     into 
        v_id_tipo_estado_registro
     from wf.ttipo_estado te
     inner join wf.ttipo_proceso tp
     	on te.id_tipo_proceso = tp.id_tipo_proceso
     inner join wf.tproceso_wf p
     	on p.id_tipo_proceso = tp.id_tipo_proceso
     where te.codigo = 'revision' and p.id_proceso_wf = p_id_proceso_wf and te.estado_reg = 'activo';


     /*Insertar el contrato con el ultimo estado*/
     INSERT INTO
          leg.tcontrato
        (
          id_usuario_reg,
          id_usuario_ai,
          usuario_ai,
          id_estado_wf,
          id_proceso_wf,
          estado,
          tipo,
          id_gestion,
          id_proveedor,
          solicitud,
          monto,
          id_moneda,
          id_cotizacion,
          contrato_adhesion,
          id_concepto_ingas,
          id_orden_trabajo,
          id_funcionario,
          rpc_regional,
          id_lugar,
          fecha_inicio,
          objeto
        )
        VALUES (
          p_id_usuario,
          p_id_usuario_ai,
          p_usuario_ai,
          p_id_estado_wf,
          p_id_proceso_wf,
          p_codigo_ewf,
          v_tipo,
          v_cotizacion.id_gestion,
          v_cotizacion.id_proveedor,
          v_solicitud,
          v_cotizacion.monto_total_adjudicado,
          v_cotizacion.id_moneda,
          p_id_cotizacion,
          --lower(coalesce(v_cotizacion.precontrato,'no')),
          (case when v_cotizacion.precontrato = 'contrato_adhesion' then 'si' else 'no' end),
          string_to_array(v_cotizacion.conceptos,',')::integer[],
          string_to_array(v_cotizacion.ots,',')::integer[],
          v_cotizacion.id_funcionario,
          (case when v_cotizacion.id_funcionario_aprobador = v_cotizacion.id_funcionario_rpc then 'si' else 'no' end),
          v_id_lugar,
          v_cotizacion.fecha_inicio,
          v_cotizacion.justificacion
        );
        
        
     --obtener sigueinte estado
     
     SELECT 
         *
      into
        va_id_tipo_estado,
        va_codigo_estado,
        va_disparador,
        va_regla,
        va_prioridad
            
    FROM wf.f_obtener_estado_wf(p_id_proceso_wf, p_id_estado_wf,NULL,'siguiente'); 
    
    v_num_estados= array_length(va_id_tipo_estado, 1);  
    
    
    IF v_num_estados = 1 then
          -- si solo hay un estado,  verificamos si tiene mas de un funcionario por este estado
         SELECT 
         *
          into
            v_num_funcionarios 
         FROM wf.f_funcionario_wf_sel(
             p_id_usuario, 
             va_id_tipo_estado[1], 
             now()::date,
             p_id_estado_wf,
             TRUE) AS (total bigint);
                                   
        IF v_num_funcionarios = 1 THEN
        -- si solo es un funcionario, recuperamos el funcionario correspondiente
             SELECT 
                 id_funcionario
                   into
                 v_id_funcionario_estado
             FROM wf.f_funcionario_wf_sel(
                 p_id_usuario, 
                 va_id_tipo_estado[1], 
                 now()::date,
                 p_id_estado_wf,
                 FALSE) 
                 AS (id_funcionario integer,
                   desc_funcionario text,
                   desc_funcionario_cargo text,
                   prioridad integer);
        END IF;    
                                   
                            
      --verificamos el numero de deptos
                            
        SELECT 
        *
        into
          v_num_deptos 
       FROM wf.f_depto_wf_sel(
           p_id_usuario, 
           va_id_tipo_estado[1], 
           now()::date,
           p_id_estado_wf,
           TRUE) AS (total bigint);
                                 
      IF v_num_deptos = 1 THEN
          -- si solo es un funcionario, recuperamos el funcionario correspondiente
               SELECT 
                   id_depto
                     into
                   v_id_depto_estado
              FROM wf.f_depto_wf_sel(
                   p_id_usuario, 
                   va_id_tipo_estado[1], 
                   now()::date,
                   p_id_estado_wf,
                   FALSE) 
                   AS (id_depto integer,
                     codigo_depto varchar,
                     nombre_corto_depto varchar,
                     nombre_depto varchar,
                     prioridad integer,
                     subsistema varchar);
        END IF;
                            
                            
     ELSE  
     
          IF v_num_estados = 0 then                     
                 raise exception 'No se encontro un estado sigueinte apra el contrato';               
          ELSE
                 raise exception 'Se encontraron variso estados posibiles para el contrato, revise sus reglas (%)', p_codigo_ewf;
          END IF;
          
                           
     END IF;
                     
                 
        
     
     /*Registrar el estado de registro*/
     v_id_estado_registro =  wf.f_registra_estado_wf(va_id_tipo_estado[1],   --p_id_tipo_estado_siguiente
                                                         v_id_funcionario_estado,
                                                         p_id_estado_wf,   --  p_id_estado_wf_anterior
                                                         p_id_proceso_wf,
                                                         p_id_usuario,
                                                         p_id_usuario_ai,
                                                         p_usuario_ai,
                                                         v_id_depto_estado,
                                                         'Paso de estado automatico por proceso de adquisiciones');
                                                         
                                                         
                                                         
                                                         

	 
     
     update leg.tcontrato
     set id_estado_wf = v_id_estado_registro,
     estado = va_codigo_estado[1]
     where id_proceso_wf = p_id_proceso_wf;
     
     
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