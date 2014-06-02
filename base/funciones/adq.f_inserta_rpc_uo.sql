--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.f_inserta_rpc_uo (
  p_administrador integer,
  p_id_usuario integer,
  p_hstore public.hstore
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.f_inserta_rpc_uo
 DESCRIPCION:   Inserta registro de relacion entre RPC y UO
 AUTOR: 		Rensi Arteaga COpar
 FECHA:	        2/6/2014
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

   
    v_parametros           	record;
   
    v_resp		            varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_rpc_uo             integer;
   
               
    v_registros record;
    v_nombre  varchar;
    v_nombre_unidad  varchar;
    
    v_sw_error boolean;
    v_cargo_nombre  varchar;
    
   
  
  
 
    
    
    
               
 
     
			    
BEGIN

    /*
    HSTORE  PARAMETERS
    
    
    
   id_categoria_compra
    fecha_ini
    fecha_fin
    monto_min
    monto_max
    _id_usuario_ai
    _nombre_usuario_ai
    id_rpc
    
    
    */
    
    v_nombre_funcion = 'f_inserta_rpc_uo';
    
            v_mensaje_error = '';
      
      
      -- chequea rango minimo
            FOR v_registros in (SELECT 
                                  DISTINCT (id_funcionario),
                                  id_rpc,
                                  id_rpc_uo,
                                  desc_funcionario,
                                  fecha_ini,
                                  fecha_fin,
                                  monto_min,
                                  monto_max,
                                  id_cargo,
                                  id_cargo_ai,
                                  ai_habilitado
                        FROM adq.f_obtener_listado_rpc(
                                  p_id_usuario,
                                 (p_hstore->'id_uo')::integer, --id_uo
                                 (p_hstore->'fecha_ini')::date, 
                                 (p_hstore->'monto_min')::numeric,
                                 (p_hstore->'id_categoria_compra')::integer,
                                 'validar'::varchar)
                                  AS ( id_rpc   integer,
                                       id_rpc_uo integer,
                                       id_funcionario integer,
                                       desc_funcionario text,
                                       fecha_ini date,
                                       fecha_fin date,
                                       monto_min numeric,
                                       monto_max numeric,
                                       id_cargo integer,
                                       id_cargo_ai integer,
                                       ai_habilitado varchar)
                                  ) LOOP
                                  
                             
                           
                               v_sw_error = TRUE;
                               
                               select 
                                c.nombre
                               into 
                                v_cargo_nombre
                              from orga.tcargo c 
                              where  c.id_cargo = v_registros.id_cargo;
    
                               v_mensaje_error=  v_mensaje_error ||v_cargo_nombre||'Monto '||(p_hstore->'monto_min')::varchar ||' Bs y fecha '||(p_hstore->'fecha_ini')||'<br/>';
                 
                 
            END LOOP;  
                 
               --  raise exception 'xxx';
           --cheque rango maximo
           
           FOR v_registros in (SELECT 
                                  DISTINCT (id_funcionario),
                                  id_rpc,
                                  id_rpc_uo,
                                  desc_funcionario,
                                  fecha_ini,
                                  fecha_fin,
                                  monto_min,
                                  monto_max,
                                  id_cargo,
                                  id_cargo_ai,
                                  ai_habilitado
                        FROM adq.f_obtener_listado_rpc(
                                  p_id_usuario,
                                 (p_hstore->'id_uo')::integer, --id_uo
                                 COALESCE((p_hstore->'fecha_fin')::date, now())::date, 
                                 COALESCE((p_hstore->'monto_max')::numeric,999999999999999.00),
                                 (p_hstore->'id_categoria_compra')::integer,
                                 'validar'::varchar)
                                  AS ( id_rpc   integer,
                                       id_rpc_uo integer,
                                       id_funcionario integer,
                                       desc_funcionario text,
                                       fecha_ini date,
                                       fecha_fin date,
                                       monto_min numeric,
                                       monto_max numeric,
                                       id_cargo integer,
                                       id_cargo_ai integer,
                                       ai_habilitado varchar)
                                  ) LOOP
                                  
                         v_sw_error = TRUE;
                               
                         select 
                          c.nombre
                         into 
                          v_cargo_nombre
                        from orga.tcargo c 
                        where  c.id_cargo = v_registros.id_cargo;
    
                        v_mensaje_error=  v_mensaje_error ||v_cargo_nombre||'Monto '||COALESCE((p_hstore->'monto_max')::numeric,999999999999999.00)::varchar ||' Bs y fecha '|| COALESCE((p_hstore->'fecha_fin')::date, now()::date)::varchar||'<br/>';
                 
                 
            END LOOP;  
                 
           
           
           IF v_sw_error THEN
                 
              raise exception 'existe otro cargos con este rango,  %', v_mensaje_error;  
                 
           END IF;
                 
                      
                    
                      
                    
                    
           --Sentencia de la insercion
            insert into adq.trpc_uo(
                        id_rpc,
                        id_uo,
                        monto_max,
                        estado_reg,
                        fecha_fin,
                        fecha_ini,
                        monto_min,
                        id_usuario_reg,
                        id_usuario_ai,
                        fecha_reg,
                        usuario_ai,
                        id_usuario_mod,
                        fecha_mod,
                        id_categoria_compra
                    ) 
              values(
                      (p_hstore->'id_rpc')::integer,
                      (p_hstore->'id_uo')::integer,
                      (p_hstore->'monto_max')::numeric,
                      'activo',
                      (p_hstore->'fecha_fin')::date,
                      (p_hstore->'fecha_ini')::date,
                      (p_hstore->'monto_min')::numeric,
                      p_id_usuario,
                      (p_hstore->'_id_usuario_ai')::integer,
                      now(),
                      (p_hstore->'_nombre_usuario_ai')::varchar,
                      null,
                      null,
                      (p_hstore->'id_categoria_compra')::integer
            							
            )RETURNING id_rpc_uo into v_id_rpc_uo;
    
    
    
			
			 return v_id_rpc_uo;




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