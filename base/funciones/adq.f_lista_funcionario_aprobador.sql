--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_lista_funcionario_aprobador (
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
 SCRIPT: 		adq.f_lista_funcionario_aprobador
 DESCRIPCIÓN: 	lista funcionariso aprobadores segun configuracion en sistema de parametros,  
                con lso datos de WF, la misma lista de aprobadores es compartida con adquisciones
 AUTOR: 		Rensi Arteaga Copari
 FECHA:			10/07/2017
 COMENTARIOS:	
***************************************************************************
 HISTORIA DE MODIFICACIONES:

 DESCRIPCIÓN:
 AUTOR:       
 FECHA:      
 ISSUE SIS       EMPRESA      FECHA:		      AUTOR       DESCRIPCION
 #1              ETR    	  	19/09/2018         EGS         se modifico para los aprobadores de los encargados  
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
    v_id_funcionario_gerente   integer;    
    v_a_eps varchar[];
    v_a_uos varchar[];
    v_uos_eps varchar;
    v_size    integer;
    v_i       integer;    
    v_reg_op    record;
    va_id_uo	integer[];
    v_id_moneda_base integer;
    v_monto_mb			numeric;
    v_id_subsistema		integer;   
    v_tam				integer;
    v_id_func_list		varchar;
    
    
    v_bandera_GG                    varchar;  --#1
    v_bandera_GAF                   varchar; --#1
    v_record_gg                     varchar[]; --#1
    v_record_gaf                    varchar[]; --#1
    v_fecha                        	date; --#1
    v_record_id_funcionario_gg      varchar; --#1
    v_record_id_funcionario_gaf     varchar; --#1
    v_integer_gg                    integer; --#1
    v_integer_gaf                   integer; --#1

BEGIN
  v_nombre_funcion ='adq.f_lista_funcionario_aprobador';
  
 
  
  
  --obtenmso datos basicos de la solicitud
   select 
      so.fecha_soli,
      so.id_funcionario,
      so.id_moneda,
      sum(sod.precio_ga_mb + sod.precio_sg_mb) as monto_pago_mb
    into
      v_reg_op
    from adq.tsolicitud so 
    inner join adq.tsolicitud_det sod  on sod.id_solicitud = so.id_solicitud
    where so.id_estado_wf = p_id_estado_wf
    group by 
      so.fecha_soli,
      so.id_funcionario,
      so.id_moneda;
      
     
  
  --obtener id_uo
  
        WITH RECURSIVE path( id_funcionario, id_uo,presupuesta, gerencia, numero_nivel) AS (
               
              SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                from orga.tuo_funcionario uofun
                inner join orga.tuo uo
                    on uo.id_uo = uofun.id_uo
                inner join orga.tnivel_organizacional no 
                                    on no.id_nivel_organizacional = uo.id_nivel_organizacional
                 where uofun.fecha_asignacion <= v_reg_op.fecha_soli and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= v_reg_op.fecha_soli)
                and uofun.estado_reg = 'activo' and uofun.id_funcionario = v_reg_op.id_funcionario
            UNION
               
             SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                from orga.testructura_uo euo
                inner join orga.tuo uo
                    on uo.id_uo = euo.id_uo_padre
                inner join orga.tnivel_organizacional no 
                                    on no.id_nivel_organizacional = uo.id_nivel_organizacional
                inner join path hijo
                    on hijo.id_uo = euo.id_uo_hijo
                left join orga.tuo_funcionario uofun
                    on uo.id_uo = uofun.id_uo and uofun.estado_reg = 'activo' and
                        uofun.fecha_asignacion <= v_reg_op.fecha_soli 
                        and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= v_reg_op.fecha_soli)
                                            
            )
             SELECT 
                pxp.aggarray(id_uo) 
              into
                va_id_uo
             FROM path 
             WHERE   id_funcionario is not null and presupuesta = 'si';
      
          
          
          select
            s.id_subsistema
           into
            v_id_subsistema
          from segu.tsubsistema s
          WHERE s.codigo = 'ADQ' and s.estado_reg = 'activo';
          
          v_tam = array_upper(va_id_uo, 1);
          v_i = 1;
          v_id_func_list='0';
          
        
          
          --raise exception 'array %',va_id_uo;
          --buscamos el aprobador subiendo por el array     
          WHILE v_i <= v_tam LOOP
             
             select 
                   pxp.list(id_funcionario::varchar)
                 into 
                    v_id_func_list    
            from 
                          
              param.f_obtener_listado_aprobadores(va_id_uo[v_i], 
              									  null,--  p_id_ep
                                                  null,--p_id_centro_costo, 
                                                  v_id_subsistema, 
                                                  v_reg_op.fecha_soli,  
                                                  v_reg_op.monto_pago_mb,  
                                                  p_id_usuario, 
                                                  null--p_id_proceso_macro
                                                  ) as 
                                                  ( id_aprobador integer,
                                                    id_funcionario integer,
                                                    fecha_ini date,
                                                    fecha_fin date,
                                                    desc_funcionario text,
                                                    monto_min numeric,
                                                    monto_max numeric,
                                                    prioridad integer);
                                                  
              IF v_id_func_list != '0' and v_id_func_list is not null  THEN
                  v_i = v_tam +1;                
              END IF;
              v_i = v_i +1  ;  
              
                                      
                                                  
          END LOOP;
          
          IF v_id_func_list is null THEN
             raise exception 'No se encontro un funcionario aprobador  para la unidad solictante y el monto (% MB) ',v_reg_op.monto_pago_mb; 
          END IF;
          
         
    	     ----#1              ETR    	  	19/09/2018         EGS  
          	v_id_func_list = split_part(v_id_func_list, ',', 1);
          	
            
            v_bandera_GG	= pxp.f_get_variable_global('orga_codigo_gerencia_general');
            v_bandera_GAF	= pxp.f_get_variable_global('orga_codigo_gerencia_financiera');    
            
            v_fecha = now();
            v_record_gg = orga.f_obtener_gerente_x_codigo_uo(v_bandera_GG,v_fecha);
            v_record_id_funcionario_gg	= v_record_gg[1];
            v_integer_gg = v_record_id_funcionario_gg::integer;
            
            v_record_gaf = orga.f_obtener_gerente_x_codigo_uo(v_bandera_GAF,v_fecha);
            v_record_id_funcionario_gaf	= v_record_gaf[1];
           -- v_integer_gaf = v_record_id_funcionario_gaf::integer;

         if( (v_reg_op.id_funcionario = v_id_func_list::integer)AND(v_reg_op.id_funcionario !=  v_integer_gg ))then
             v_i = 2;
             
             WHILE v_i <= v_tam LOOP
               
               select 
                     pxp.list(id_funcionario::varchar)
                   into 
                      v_id_func_list    
              from 
                            
                param.f_obtener_listado_aprobadores(va_id_uo[v_i], 
                                                    null,--  p_id_ep
                                                    null,--p_id_centro_costo, 
                                                    v_id_subsistema, 
                                                    v_reg_op.fecha_soli,  
                                                    v_reg_op.monto_pago_mb,  
                                                    p_id_usuario, 
                                                    null--p_id_proceso_macro
                                                    ) as 
                                                    ( id_aprobador integer,
                                                      id_funcionario integer,
                                                      fecha_ini date,
                                                      fecha_fin date,
                                                      desc_funcionario text,
                                                      monto_min numeric,
                                                      monto_max numeric,
                                                      prioridad integer);
                                                    
                IF v_id_func_list != '0' and v_id_func_list is not null  THEN
                    v_i = v_tam +1;                
                END IF;
                v_i = v_i +1  ;  
                                          
          END LOOP;
          elseif(v_reg_op.id_funcionario =  v_integer_gg)then
          		v_id_func_list = v_record_id_funcionario_gaf;
         
         end if;
    		
         ----#1              ETR    	  	19/09/2018         EGS  
          -- RAISE exception 'hola %',v_id_func_list ;
            
     
    
   
    IF not p_count then
    
             v_consulta:='SELECT
                            fun.id_funcionario,
                            fun.desc_funcionario1 as desc_funcionario,
                            ''Gerente''::text  as desc_funcionario_cargo,
                            1 as prioridad
                         FROM orga.vfuncionario fun WHERE fun.id_funcionario in('||v_id_func_list||') 
                         and '||p_filtro||'
                         limit '|| p_limit::varchar||' offset '||p_start::varchar; 
     
              
                   FOR g_registros in execute (v_consulta)LOOP     
                     RETURN NEXT g_registros;
                   END LOOP;
                      
      ELSE
                  v_consulta='select
                                  COUNT(fun.id_funcionario) as total
                                 FROM orga.vfuncionario fun  WHERE fun.id_funcionario in('||v_id_func_list||') 
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