--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_lista_funcionario_resp_adq (
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
 SCRIPT: 		adq.f_lista_funcionario_resp_adq
 DESCRIPCIÓN: 	lista responsable del depatamento de adquisiciones
 AUTOR: 		Rensi Arteaga
 FECHA:			19/12/2017
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
     v_id_funcionario_resp_adq   integer;
    
    v_a_eps varchar[];
    v_a_uos varchar[];
    v_uos_eps varchar;
    v_size    integer;
    v_i       integer;
    v_id_depto_adq		integer;

BEGIN
  v_nombre_funcion ='adq.f_lista_funcionario_resp_adq';

    --recuperamos la la opbligacion de pago a partir del is_Estado_wf en el plan de pagos
    
    select 
      op.id_depto
    into
      v_id_depto_adq
    from adq.tsolicitud op
    where op.id_estado_wf = p_id_estado_wf;
    
    select 
      fun.id_funcionario
     into 
       v_id_funcionario_resp_adq
    from  param.tdepto_usuario du
    inner join segu.tusuario usu on usu.id_usuario = du.id_usuario
    inner join orga.tfuncionario fun on fun.id_persona = usu.id_persona   
    where     du.id_depto = v_id_depto_adq
          and du.cargo = 'responsable'
          OFFSET 0 limit 1;
          
    IF v_id_funcionario_resp_adq is null THEN
        raise exception 'no se encontro un funcionario responsable  para el departametno de ADQ id= %',v_id_depto_adq;
    END IF;
    
   
    IF not p_count then
    
             v_consulta:='SELECT
                            fun.id_funcionario,
                            fun.desc_funcionario1 as desc_funcionario,
                            ''''::text  as desc_funcionario_cargo,
                            1 as prioridad
                         FROM orga.vfuncionario fun WHERE fun.id_funcionario = '||COALESCE(v_id_funcionario_resp_adq,0)::varchar||'
                         and '||p_filtro||'
                         limit '|| p_limit::varchar||' offset '||p_start::varchar; 
     
              
                   FOR g_registros in execute (v_consulta)LOOP     
                     RETURN NEXT g_registros;
                   END LOOP;
                      
      ELSE
                  v_consulta='select
                                  COUNT(fun.id_funcionario) as total
                                 FROM orga.vfuncionario fun WHERE fun.id_funcionario = '||COALESCE(v_id_funcionario_resp_adq,0)::varchar||'
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