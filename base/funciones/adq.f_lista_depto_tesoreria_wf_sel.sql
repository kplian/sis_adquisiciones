--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_lista_depto_tesoreria_wf_sel (
  p_id_usuario integer,
  p_id_tipo_estado integer,
  p_fecha date = now(),
  p_id_estado_wf integer = NULL::integer,
  p_count boolean = false,
  p_limit integer = 1,
  p_start integer = 0,
  p_filtro varchar = '0=0'::character varying
)
RETURNS SETOF record AS
$body$
/**************************************************************************
 SISTEMA ENDESIS - SISTEMA DE ...
***************************************************************************
 SCRIPT: 		adq.f_lista_depto_tesoreria_wf_sel
 DESCRIPCIÓN: 	Lista los departmatos de tesoreia que coinciden con la EP y UP de la cotizacion adjudicada
 AUTOR: 		Rensi Arteaga Copari
 FECHA:			29/04/2014
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCIÓN:
 AUTOR:       
 FECHA:      

***************************************************************************/

-------------------------
-- CUERPO DE LA FUNCIÓN --
--------------------------

-- PARÁMETROS FIJOS
/*


  p_id_usuario integer,                                identificador del actual usuario de sistema
  p_id_tipo_estado integer,                            idnetificador del tipo estado del que se quiere obtener el listado de funcionario  (se correponde con tipo_estado que le sigue a id_estado_wf proporcionado)                       
  p_fecha date = now(),                                fecha  --para verificar asginacion de cargo con organigrama
  p_id_estado_wf integer = NULL::integer,              identificaro de estado_wf actual en el proceso_wf
  p_count boolean = false,                             si queremos obtener numero de funcionario = true por defecto false
  p_limit integer = 1,                                 los siguiente son parametros para filtrar en la consulta
  p_start integer = 0,
  p_filtro varchar = '0=0'::character varying




*/

DECLARE
	g_registros  		record;
    v_depto_asignacion    varchar;
    v_nombre_depto_func_list   varchar;
    
    v_consulta varchar;
    v_nombre_funcion varchar;
    v_resp varchar;
    
    
     v_cad_ep varchar;
     v_cad_uo varchar;
    v_id_cotizacion   integer;
    
    v_a_eps varchar[];
    v_a_uos varchar[];
    v_uos_eps varchar;
    v_size    integer;
    v_i       integer;
    v_codigo_subsistema	varchar;
    v_id_tabla		integer;

BEGIN
  v_nombre_funcion ='adq.f_lista_depto_tesoreria_wf_sel';

    --recuperamos la cotizacion a partir del id_estado_wf
    select sub.codigo into v_codigo_subsistema
    from wf.testado_wf e
    inner join wf.tproceso_wf p on p.id_proceso_wf = e.id_proceso_wf
    inner join wf.ttipo_proceso tp on tp.id_tipo_proceso = p.id_tipo_proceso
    inner join wf.tproceso_macro pm on pm.id_proceso_macro = tp.id_proceso_macro
    inner join segu.tsubsistema sub on sub.id_subsistema = pm.id_subsistema
    where e.id_estado_wf = p_id_estado_wf;
    
    if (v_codigo_subsistema = 'ADQ') then
          select 
            c.id_cotizacion
          into
            v_id_cotizacion
          from adq.tcotizacion c
          where c.id_estado_wf = p_id_estado_wf;
          
          --recuperamos las uo y ep de items adjudicados de la cotizacion 
          select 
                  pxp.list(cc.id_uo::text),
                  pxp.list(cc.id_ep::text)
                into
                  v_cad_uo,
                  v_cad_ep
                from adq.tcotizacion_det cd
                inner join adq.tsolicitud_det sd on sd.id_solicitud_det = cd.id_solicitud_det
                inner join param.tcentro_costo cc on sd.id_centro_costo = cc.id_centro_costo
                where cd.id_cotizacion = v_id_cotizacion 
                and cd.estado_reg = 'activo' and cd.cantidad_adju > 0;
        ELSE
        	select 
              p.id_planilla
            into
              v_id_tabla
            from plani.tplanilla p
            where p.id_estado_wf = p_id_estado_wf;
            
            --recuperamos las uo y ep de items adjudicados de la cotizacion 
            select 
              pxp.list(cc.id_uo::text),
              pxp.list(cc.id_ep::text)
            into
              v_cad_uo,
              v_cad_ep
            from plani.tplanilla p
            inner join plani.tconsolidado c on c.id_planilla = p.id_planilla
            inner join param.tcentro_costo cc on c.id_presupuesto = cc.id_centro_costo
            where p.id_planilla = v_id_tabla;
            v_cad_ep = '1';
            v_cad_uo = '3';
        end if;
    
          raise notice '>>>> %,%',v_cad_uo,v_cad_ep;
   
          v_a_eps = string_to_array(v_cad_ep, ',');
          v_a_uos = string_to_array(v_cad_uo, ',');
          v_size :=array_upper(v_a_eps,1);
           
          
          
          for v_i IN 1..v_size
          Loop
          
             IF v_i =1 THEN
               v_uos_eps='('||v_a_eps[v_i]||','||v_a_uos[v_i]||')';
          	 ELSE
              v_uos_eps=v_uos_eps||',('||v_a_eps[v_i]||','||v_a_uos[v_i]||')';
             END IF;
          
          END Loop;
          
   
    IF not p_count then
    
    
              v_consulta:='SELECT 
                              DISTINCT (DEPPTO.id_depto),
                               DEPPTO.codigo as codigo_depto,
                               DEPPTO.nombre_corto as nombre_corto_depto,
                               DEPPTO.nombre as nombre_depto,
                               1 as prioridad,
                               SUBSIS.nombre as subsistema
                            FROM param.tdepto DEPPTO
                            INNER JOIN segu.tsubsistema SUBSIS on SUBSIS.id_subsistema=DEPPTO.id_subsistema
                            inner join param.tdepto_uo_ep due on 
                                due.id_depto = DEPPTO.id_depto and due.estado_reg = ''activo'' 
                            WHERE  DEPPTO.estado_reg = ''activo'' and
                               (
                                (due.id_ep,due.id_uo) in ('||v_uos_eps||')
                                 or
                                (due.id_uo is null and  due.id_ep in ('||v_cad_ep||') ) 
                                 or 
                                (due.id_ep is null and  due.id_uo in ('||v_cad_uo||') )
                               )
                              and (SUBSIS.codigo = ''TES'' and DEPPTO.modulo=''OP'') and '||p_filtro||'
                      limit '|| p_limit::varchar||' offset '||p_start::varchar; 
                      
                                         
                   FOR g_registros in execute (v_consulta)LOOP     
                     RETURN NEXT g_registros;
                   END LOOP;
                      
      ELSE
                  v_consulta='select
                                  COUNT(DEPPTO.id_depto) as total
                                  FROM param.tdepto DEPPTO
                                  INNER JOIN segu.tsubsistema SUBSIS on SUBSIS.id_subsistema=DEPPTO.id_subsistema
                                  inner join param.tdepto_uo_ep due on due.id_depto = DEPPTO.id_depto and due.estado_reg = ''activo'' 
                                where DEPPTO.estado_reg = ''activo'' and
                                
                                (
                                        (due.id_ep,due.id_uo) in ('||v_uos_eps||')
                                         or
                                        (due.id_uo is null and  due.id_ep in ('||v_cad_ep||') ) 
                                         or 
                                        (due.id_ep is null and  due.id_uo in ('||v_cad_uo||') )
                                       )
                                      and (SUBSIS.codigo = ''TES''  and DEPPTO.modulo=''OP'') and '||p_filtro;   
                                          
                   FOR g_registros in execute (v_consulta)LOOP     
                     RETURN NEXT g_registros;
                   END LOOP;
                       
                       
    END IF;
               
        
       
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
COST 100 ROWS 1000;