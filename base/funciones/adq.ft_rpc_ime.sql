--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_rpc_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_rpc_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.trpc'
 AUTOR: 		 (rac)
 FECHA:	        29-05-2014 15:57:51
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
	v_id_rpc	integer;
			    
BEGIN

    v_nombre_funcion = 'adq.ft_rpc_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_RPC_INS'
 	#DESCRIPCION:	Insercion de registros de rpc
 	#AUTOR:		rac	
 	#FECHA:		29-05-2014 15:57:51
	***********************************/

	if(p_transaccion='ADQ_RPC_INS')then
					
        begin
        	
            -- chequea que el cargo  no este duplicado
            
            
            IF exists(select 1 
                       from adq.trpc r   
                       where r.id_cargo = v_parametros.id_cargo 
                         and r.estado_reg = 'activo') THEN
                   
            
                raise exception 'El cargo ya se encuentra registrado como RPC';
                  
            END IF;  
            
            
            --Sentencia de la insercion
        	insert into adq.trpc(
			id_cargo,
			id_cargo_ai,
			estado_reg,
			ai_habilitado,
			id_usuario_reg,
			id_usuario_ai,
			usuario_ai,
			fecha_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_cargo,
			v_parametros.id_cargo_ai,
			'activo',
			v_parametros.ai_habilitado,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null
							
			
			
			)RETURNING id_rpc into v_id_rpc;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC almacenado(a) con exito (id_rpc'||v_id_rpc||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc',v_id_rpc::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_RPC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		rac	
 	#FECHA:		29-05-2014 15:57:51
	***********************************/

	elsif(p_transaccion='ADQ_RPC_MOD')then

		begin
			
             -- chequea  que el cargo  no este duplicado
            IF exists(select 1 
                       from adq.trpc r   
                       where r.id_cargo = v_parametros.id_cargo 
                         and r.estado_reg = 'activo'  and  r.id_rpc != v_parametros.id_rpc ) THEN
                   
            
                raise exception 'El cargo ya se encuentra registrado como RPC';
                  
            END IF; 
            
            --Sentencia de la modificacion
			update adq.trpc set
			id_cargo = v_parametros.id_cargo,
			id_cargo_ai = v_parametros.id_cargo_ai,
			ai_habilitado = v_parametros.ai_habilitado,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_rpc=v_parametros.id_rpc;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc',v_parametros.id_rpc::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_RPC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		rac	
 	#FECHA:		29-05-2014 15:57:51
	***********************************/

	elsif(p_transaccion='ADQ_RPC_ELI')then

		begin
			--Sentencia de la eliminacion
			update adq.trpc set
            estado_reg = 'inactivo'
            where id_rpc=v_parametros.id_rpc;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','RPC eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_rpc',v_parametros.id_rpc::varchar);
              
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