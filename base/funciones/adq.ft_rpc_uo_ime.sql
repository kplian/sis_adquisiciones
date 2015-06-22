--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_rpc_uo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_rpc_uo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.trpc_uo'
 AUTOR: 		 (admin)
 FECHA:	        29-05-2014 15:58:17
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_rpc_uo	integer;
   
    v_nombre           varchar;
    v_id_uos           integer[];
    v_tamano           integer;
    v_nombre_unidad    varchar;
    v_i                integer;
			    
BEGIN

    v_nombre_funcion = 'adq.ft_rpc_uo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_RUO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-05-2014 15:58:17
	***********************************/
/*
	if(p_transaccion='ADQ_RUO_INS')then
					
        begin
        
        
             --insertamos los roles del usuario
             v_id_uos= string_to_array(v_parametros.id_uos,',');
             v_tamano = coalesce(array_length(v_id_uos, 1),0);
          
          FOR v_i IN 1..v_tamano LOOP
         
                      --validar que no exista otro rpc para la misma uo
                      --misma categoria, mismos montos y mismas fechas ...
                      --( se se realizan cambio tambien hacerlos para el caso de update)
                     
                      select
                          ruo.id_rpc_uo 
                      into 
                        v_id_rpc_uo
                      from adq.trpc_uo ruo
                      where 
                         ruo.estado_reg = 'activo' and
                         ruo.id_uo = v_id_uos[v_i]  and
                         ruo.id_categoria_compra = v_parametros.id_categoria_compra 
                        
                         AND 
                         (      
                            (
                                   (   
                                           ruo.monto_max is NULL 
                                      and  v_parametros.monto_max is NULL
                                   )
                                   or 
                                   (
                                         (   
                                           ( v_parametros.monto_max <= ruo.monto_max
                                        and  
                                            v_parametros.monto_max >= ruo.monto_min )
                                        
                                        or
                                        
                                        ( v_parametros.monto_min <= ruo.monto_max
                                        and  v_parametros.monto_min >= ruo.monto_min )
                                        )
                                   )
                            )
                            
                          )
                          and
                          (  
                           
                            (
                                         ruo.fecha_fin is NULL
                                   and  v_parametros.fecha_fin is NULL
                            )
                            
                            or 
                                   (
                                         (   
                                           ( v_parametros.fecha_fin <= ruo.fecha_fin
                                        and  
                                            v_parametros.fecha_fin >= ruo.fecha_ini )
                                        
                                        or
                                        
                                        ( v_parametros.fecha_ini <= ruo.fecha_fin
                                        and  v_parametros.fecha_ini >= ruo.fecha_ini )
                                        )
                                   )
                                
                            );
                         
                         
                        IF v_id_rpc_uo is not null  THEN   
                          
                            select  
                              car.nombre 
                            into
                               v_nombre
                            from adq.trpc_uo ruo
                            inner join adq.trpc rpc on rpc.id_rpc =  ruo.id_rpc
                            inner join orga.tcargo car on car.id_cargo =   rpc.id_cargo
                            where ruo.id_rpc_uo = v_id_rpc_uo;
                            
                            select 
                            uo.nombre_unidad
                            into
                            v_nombre_unidad
                            from orga.tuo uo
                            where uo.id_uo =  v_id_uos[v_i];
                            
                            
                            raise exception 'existe un registro para el mismo rango, con el cargo: % en la unidad %',v_nombre, v_nombre_unidad;
                          
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
                        ) values(
                        v_parametros.id_rpc,
                        v_id_uos[v_i],
                        v_parametros.monto_max,
                        'activo',
                        v_parametros.fecha_fin,
                        v_parametros.fecha_ini,
                        v_parametros.monto_min,
                        p_id_usuario,
                        v_parametros._id_usuario_ai,
                        now(),
                        v_parametros._nombre_usuario_ai,
                        null,
                        null,
                        v_parametros.id_categoria_compra
            							
            			
            			
                        )RETURNING id_rpc_uo into v_id_rpc_uo;
            
            
            END LOOP;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC UO almacenado(a) con exito (id_rpc_uo'||v_id_rpc_uo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc_uo',v_id_rpc_uo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;*/

/*********************************    
 	#TRANSACCION:  'ADQ_RUO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-05-2014 15:58:17
	***********************************/

	if(p_transaccion='ADQ_RUO_INS')then
					
        begin
        
        
             --insertamos los roles del usuario
             v_id_uos= string_to_array(v_parametros.id_uos,',');
             v_tamano = coalesce(array_length(v_id_uos, 1),0);
          
            FOR v_i IN 1..v_tamano LOOP
         
                
                 v_parametros.id_uo = v_id_uos[v_i];
                 v_id_rpc_uo =  adq.f_inserta_rpc_uo(p_administrador, p_id_usuario, hstore(v_parametros));
               
            
            
            END LOOP;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC UO almacenado(a) con exito (id_rpc_uo'||v_id_rpc_uo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc_uo',v_id_rpc_uo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_RUO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rac	
 	#FECHA:		29-05-2014 15:58:17
	***********************************/

	elsif(p_transaccion='ADQ_RUO_MOD')then

		begin
			
           
          --validar que no exista otro rpc para la misma uo
          --misma categoria, mismos montos y mismas fechas ...
          --( se se realizan cambio tambien hacerlos para el caso de insercion)
          
           select
              ruo.id_rpc_uo 
          into 
            v_id_rpc_uo
          from adq.trpc_uo ruo
          where 
             ruo.id_rpc_uo != v_parametros.id_rpc_uo and
             ruo.estado_reg = 'activo' and
             ruo.id_uo = v_parametros.id_uo  and
             ruo.id_categoria_compra = v_parametros.id_categoria_compra 
            
             AND 
             (      
                (
                       (   
                               ruo.monto_max is NULL 
                          and  v_parametros.monto_max is NULL
                       )
                       or 
                       (
                             (   
                               ( v_parametros.monto_max <= ruo.monto_max
                            and  
                                v_parametros.monto_max >= ruo.monto_min )
                            
                            or
                            
                            ( v_parametros.monto_min <= ruo.monto_max
                            and  v_parametros.monto_min >= ruo.monto_min )
                            )
                       )
                )
                
              )
              and
              (  
               
                (
                             ruo.fecha_fin is NULL
                       and  v_parametros.fecha_fin is NULL
                )
                
                or 
                       (
                             (   
                               ( v_parametros.fecha_fin <= ruo.fecha_fin
                            and  
                                v_parametros.fecha_fin >= ruo.fecha_ini )
                            
                            or
                            
                            ( v_parametros.fecha_ini <= ruo.fecha_fin
                            and  v_parametros.fecha_ini >= ruo.fecha_ini )
                            )
                       )
                    
                );
             
             
            IF v_id_rpc_uo is not null  THEN   
              
                select  
                  car.nombre 
                into
                   v_nombre
                from adq.trpc_uo ruo
                inner join adq.trpc rpc on rpc.id_rpc =  ruo.id_rpc
                inner join orga.tcargo car on car.id_cargo =   rpc.id_cargo
                where ruo.id_rpc_uo = v_id_rpc_uo;
                
                raise exception 'existe un registro para el mismo rango, con el cargo: %',v_nombre;
              
            END IF;  
            
            
            
            
            
            
            --Sentencia de la modificacion
			update adq.trpc_uo set
			id_rpc = v_parametros.id_rpc,
			id_uo = v_parametros.id_uo,
			monto_max = v_parametros.monto_max,
			fecha_fin = v_parametros.fecha_fin,
			fecha_ini = v_parametros.fecha_ini,
			monto_min = v_parametros.monto_min,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_categoria_compra = v_parametros.id_categoria_compra
			where id_rpc_uo=v_parametros.id_rpc_uo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC UO modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc_uo',v_parametros.id_rpc_uo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_RUO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		29-05-2014 15:58:17
	***********************************/

	elsif(p_transaccion='ADQ_RUO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from adq.trpc_uo
            where id_rpc_uo=v_parametros.id_rpc_uo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC UO eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc_uo',v_parametros.id_rpc_uo::varchar);
              
            --Devuelve la respuesta
            return v_resp;

		end;
         
	else
     
    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

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