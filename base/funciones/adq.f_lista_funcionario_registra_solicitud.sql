--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_lista_funcionario_registra_solicitud (
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
 SISTEMA ENDESIS - SISTEMA DE ADQUISICIONES
***************************************************************************
 SCRIPT: 		adq.f_lista_funcionario_registra_solicitud
 DESCRIPCIÓN: 	Lista el funcionario quien registra una solicitud
 AUTOR: 		Franklin Espinoza A.
 FECHA:			19/05/2017
 COMENTARIOS:
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCIÓN: 
 AUTOR: 
 FECHA:

***************************************************************************/



DECLARE
	g_registros  		record;
    v_depto_asignacion    varchar;

    v_consulta varchar;
    v_nombre_funcion varchar;
    v_resp varchar;

    v_id_usuario_reg  integer;
    v_id_funcionario integer;

BEGIN

    v_nombre_funcion ='adq.f_lista_funcionario_registra_solicitud';
	
   
    SELECT ts.id_funcionario
    INTO v_id_funcionario
    FROM wf.testado_wf tew
    INNER JOIN adq.tcotizacion tc ON tc.id_proceso_wf = tew.id_proceso_wf
    INNER JOIN adq.tproceso_compra tpc ON tpc.id_proceso_compra = tc.id_proceso_compra
    INNER JOIN adq.tsolicitud ts ON ts.id_solicitud = tpc.id_solicitud
    WHERE tew.id_estado_wf = p_id_estado_wf;
                                                                         
    IF not p_count then
             v_consulta:='SELECT
                            fun.id_funcionario,
                            fun.desc_funcionario1 as desc_funcionario,
                            ''Gerente''::text  as desc_funcionario_cargo,
                            1 as prioridad
                         FROM orga.vfuncionario fun WHERE fun.id_funcionario = '||COALESCE(v_id_funcionario,0)::varchar||'
                         and '||p_filtro||'
                         limit '|| p_limit::varchar||' offset '||p_start::varchar;
                         
                     


                   FOR g_registros in execute (v_consulta)LOOP
                     RETURN NEXT g_registros;
                   END LOOP;

      ELSE
                  v_consulta='select
                                  COUNT(fun.id_funcionario) as total
                                 FROM orga.vfuncionario fun WHERE fun.id_funcionario = '||COALESCE(v_id_funcionario,0)::varchar||'
                                 and '||p_filtro;

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