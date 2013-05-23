--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_grupo_partida_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_grupo_partida_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tgrupo_partida'
 AUTOR: 		 (admin)
 FECHA:	        09-05-2013 22:46:52
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
	v_id_grupo_partida	integer;
			    
BEGIN

    v_nombre_funcion = 'adq.ft_grupo_partida_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_GRPA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:52
	***********************************/

	if(p_transaccion='ADQ_GRPA_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into adq.tgrupo_partida(
			id_partida,
			id_grupo,
			estado_reg,
			id_usuario_reg,
			fecha_reg,
			fecha_mod,
			id_usuario_mod,
            id_gestion
          	) values(
			v_parametros.id_partida,
			v_parametros.id_grupo,
			'activo',
			p_id_usuario,
			now(),
			null,
			null,
            v_parametros.id_gestion
							
			)RETURNING id_grupo_partida into v_id_grupo_partida;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partidad almacenado(a) con exito (id_grupo_partida'||v_id_grupo_partida||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_partida',v_id_grupo_partida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_GRPA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:52
	***********************************/

	elsif(p_transaccion='ADQ_GRPA_MOD')then

		begin
			--Sentencia de la modificacion
			update adq.tgrupo_partida set
			id_partida = v_parametros.id_partida,
			id_grupo = v_parametros.id_grupo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
            id_gestion= v_parametros.id_gestion
			where id_grupo_partida=v_parametros.id_grupo_partida;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partidad modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_partida',v_parametros.id_grupo_partida::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_GRPA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		09-05-2013 22:46:52
	***********************************/

	elsif(p_transaccion='ADQ_GRPA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from adq.tgrupo_partida
            where id_grupo_partida=v_parametros.id_grupo_partida;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Partidad eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_partida',v_parametros.id_grupo_partida::varchar);
              
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