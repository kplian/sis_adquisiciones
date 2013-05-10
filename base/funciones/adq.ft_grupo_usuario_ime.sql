CREATE OR REPLACE FUNCTION "adq"."ft_grupo_usuario_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_grupo_usuario_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tgrupo_usuario'
 AUTOR: 		 (admin)
 FECHA:	        09-05-2013 22:46:48
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
	v_id_grupo_usuario	integer;
			    
BEGIN

    v_nombre_funcion = 'adq.ft_grupo_usuario_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_GRUS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:48
	***********************************/

	if(p_transaccion='ADQ_GRUS_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into adq.tgrupo_usuario(
			estado_reg,
			id_usuario,
			obs,
			id_grupo,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_usuario,
			v_parametros.obs,
			v_parametros.id_grupo,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_grupo_usuario into v_id_grupo_usuario;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Usuarios almacenado(a) con exito (id_grupo_usuario'||v_id_grupo_usuario||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_usuario',v_id_grupo_usuario::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_GRUS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:48
	***********************************/

	elsif(p_transaccion='ADQ_GRUS_MOD')then

		begin
			--Sentencia de la modificacion
			update adq.tgrupo_usuario set
			id_usuario = v_parametros.id_usuario,
			obs = v_parametros.obs,
			id_grupo = v_parametros.id_grupo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_grupo_usuario=v_parametros.id_grupo_usuario;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Usuarios modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_usuario',v_parametros.id_grupo_usuario::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_GRUS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:48
	***********************************/

	elsif(p_transaccion='ADQ_GRUS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from adq.tgrupo_usuario
            where id_grupo_usuario=v_parametros.id_grupo_usuario;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Usuarios eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_usuario',v_parametros.id_grupo_usuario::varchar);
              
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "adq"."ft_grupo_usuario_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
