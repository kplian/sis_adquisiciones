--------------- SQL ---------------

CREATE OR REPLACE FUNCTION adq.ft_comision_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Adquisiciones
 FUNCION: 		adq.ft_comision_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'rec.tmotivo_anulado'
 AUTOR: 		 (admin)
 FECHA:	        13-04-2017 14:36:54
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
	v_id_integrante			integer;
			    
BEGIN

    v_nombre_funcion = 'adq.ft_comision_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ADQ_COM_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2017 14:36:54
	***********************************/

	if(p_transaccion='ADQ_COM_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into adq.tcomision(
			id_funcionario,
            orden,
			estado_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_funcionario,
            v_parametros.orden,
			'activo',
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_integrante into v_id_integrante;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Integrante almacenado(a) con exito (id_integrante'||v_id_integrante||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_integrante',v_id_integrante::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_COM_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2017 14:36:54
	***********************************/

	elsif(p_transaccion='ADQ_COM_MOD')then

		begin
			--Sentencia de la modificacion
			update adq.tcomision set
			id_funcionario = v_parametros.id_funcionario,
            orden = v_parametros.orden,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_integrante=v_parametros.id_integrante;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Integrante modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_integrante',v_parametros.id_integrante::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ADQ_COM_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin	
 	#FECHA:		13-04-2017 14:36:54
	***********************************/

	elsif(p_transaccion='ADQ_COM_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from adq.tcomision
            where id_integrante=v_parametros.id_integrante;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Integrante eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_integrante',v_parametros.id_integrante::varchar);
              
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