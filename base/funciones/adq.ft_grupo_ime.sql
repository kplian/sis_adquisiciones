CREATE OR REPLACE FUNCTION "adq"."ft_grupo_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_grupo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tgrupo'
 AUTOR: 		 (admin)
 FECHA:	        09-05-2013 22:34:29
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
	v_id_grupo	integer;
			    
BEGIN

    v_nombre_funcion = 'adq.ft_grupo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_GRU_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:34:29
	***********************************/

	if(p_transaccion='ADQ_GRU_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into adq.tgrupo(
			estado_reg,
			nombre,
			obs,
			fecha_reg,
			id_usuario_reg,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.nombre,
			v_parametros.obs,
			now(),
			p_id_usuario,
			null,
			null
							
			)RETURNING id_grupo into v_id_grupo;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Grupo de Presolicitudes almacenado(a) con exito (id_grupo'||v_id_grupo||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo',v_id_grupo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_GRU_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:34:29
	***********************************/

	elsif(p_transaccion='ADQ_GRU_MOD')then

		begin
			--Sentencia de la modificacion
			update adq.tgrupo set
			nombre = v_parametros.nombre,
			obs = v_parametros.obs,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now()
			where id_grupo=v_parametros.id_grupo;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Grupo de Presolicitudes modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo',v_parametros.id_grupo::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_GRU_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:34:29
	***********************************/

	elsif(p_transaccion='ADQ_GRU_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from adq.tgrupo
            where id_grupo=v_parametros.id_grupo;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Grupo de Presolicitudes eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo',v_parametros.id_grupo::varchar);
              
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
ALTER FUNCTION "adq"."ft_grupo_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
