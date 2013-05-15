--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_presolicitud_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_presolicitud_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'adq.tpresolicitud'
 AUTOR: 		 (admin)
 FECHA:	        10-05-2013 05:03:41
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
	v_id_presolicitud	integer;
			    
BEGIN

    v_nombre_funcion = 'adq.ft_presolicitud_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_PRES_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	if(p_transaccion='ADQ_PRES_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into adq.tpresolicitud(
			id_grupo,
			id_funcionario_supervisor,
			id_funcionario,
			estado_reg,
			obs,
			id_uo,
			estado,
		
			fecha_reg,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod,
            fecha_soli
          	) values(
			v_parametros.id_grupo,
			v_parametros.id_funcionario_supervisor,
			v_parametros.id_funcionario,
			'activo',
			v_parametros.obs,
			v_parametros.id_uo,
			'borrador',
		
			now(),
			p_id_usuario,
			null,
			null,
            v_parametros.fecha_soli
							
			)RETURNING id_presolicitud into v_id_presolicitud;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolicitud almacenado(a) con exito (id_presolicitud'||v_id_presolicitud||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_id_presolicitud::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PRES_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	elsif(p_transaccion='ADQ_PRES_MOD')then

		begin
			--Sentencia de la modificacion
			update adq.tpresolicitud set
			id_grupo = v_parametros.id_grupo,
			id_funcionario_supervisor = v_parametros.id_funcionario_supervisor,
			id_funcionario = v_parametros.id_funcionario,
			obs = v_parametros.obs,
			id_uo = v_parametros.id_uo,
			
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario
			where id_presolicitud=v_parametros.id_presolicitud;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolicitud modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_PRES_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		10-05-2013 05:03:41
	***********************************/

	elsif(p_transaccion='ADQ_PRES_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from adq.tpresolicitud
            where id_presolicitud=v_parametros.id_presolicitud;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Presolicitud eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_presolicitud',v_parametros.id_presolicitud::varchar);
              
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